import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie/constants.dart';
import 'package:movie/screens/home/components/body.dart';
import 'package:movie/screens/home/components/movie_card.dart';
import 'package:movie/state/app_state.dart';
import 'package:movie/models/movie.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Body(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        padding: EdgeInsets.only(left: kDefaultPadding),
        icon: SvgPicture.asset("assets/icons/menu.svg"),
        onPressed: () {},
      ),
      actions: <Widget>[
        IconButton(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          icon: const Icon(Icons.favorite_outline, color: Colors.black),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(
                    title: const Text('Favorites'),
                  ),
                  body: FavoritesBody(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}



class FavoritesBody extends StatefulWidget {
  @override
  _FavoritesBodyState createState() => _FavoritesBodyState();
}

class _FavoritesBodyState extends State<FavoritesBody> {
  late PageController _pageController;
  int initialPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: initialPage,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateWidget.of(context);
    final List<Movie> favs = appState.favoriteMovies;

    if (favs.isEmpty) {
      return Center(
        child: Text(
          'No favorites yet',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Column(
        children: [
          SizedBox(height: 20), // ini bikin carousel turun sedikit
          AspectRatio(
            aspectRatio: 0.85,
            child: PageView.builder(
              controller: _pageController,
              itemCount: favs.length,
              onPageChanged: (value) {
                setState(() {
                  initialPage = value;
                });
              },
              itemBuilder: (context, index) {
                double value = 0;
                if (_pageController.hasClients && _pageController.position.haveDimensions) {
                  value = index - _pageController.page!;
                  value = (value * 0.038).clamp(-1, 1);
                }
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 350),
                  opacity: initialPage == index ? 1 : 0.4,
                  child: Transform.rotate(
                    angle: 3.14159265 * value,
                    child: MovieCard(movie: favs[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}