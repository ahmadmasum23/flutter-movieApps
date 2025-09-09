import 'package:flutter/material.dart';
import 'package:movie/viewmodels/home_viewmodel.dart';
import 'package:movie/viewmodels/theme_viewmodel.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:movie/screens/details/details_screen.dart';
import 'package:movie/models/movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _initialPage = 0;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: _initialPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeViewModel = Provider.of<ThemeViewModel>(context);
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);

    return DefaultTabController(
      length: homeViewModel.categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  onChanged: (value) => homeViewModel.search(value),
                  decoration: const InputDecoration(
                    hintText: 'Search Movies...',
                    border: InputBorder.none,
                  ),
                )
              : const Text('Movies'),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    homeViewModel.search('');
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(themeViewModel.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode),
              onPressed: () {
                themeViewModel.toggleTheme();
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: homeViewModel.categories
                .map((category) => Tab(text: category))
                .toList(),
            onTap: (index) => homeViewModel.selectCategory(index),
          ),
        ),
        body: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: PageView.builder(
                controller: _pageController,
                itemCount: viewModel.movieList.length,
                onPageChanged: (value) {
                  setState(() {
                    _initialPage = value;
                  });
                },
                itemBuilder: (context, index) {
                  double value = 0;
                  if (_pageController.position.haveDimensions) {
                    value = index - _pageController.page!;
                    value = (value * 0.038).clamp(-1, 1);
                  }
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 350),
                    opacity: _initialPage == index ? 1 : 0.4,
                    child: Transform.rotate(
                      angle: 3.14159265 * value,
                      child: MovieCard(movie: viewModel.movieList[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class MovieCard extends StatefulWidget {
  final Movie movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  Color? _dominantColor;

  @override
  void initState() {
    super.initState();
    _updateDominantColor();
  }

  Future<void> _updateDominantColor() async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      AssetImage(widget.movie.poster),
    );
    setState(() {
      _dominantColor = paletteGenerator.dominantColor?.color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(movie: widget.movie),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        elevation: 4.0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            gradient: LinearGradient(
              colors: [
                _dominantColor ?? Colors.transparent,
                _dominantColor?.withOpacity(0.7) ?? Colors.transparent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Hero(
                  tag: widget.movie.id,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    child: Image.asset(
                      widget.movie.poster,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.movie.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
