import 'package:flutter/material.dart';
import 'package:movie/models/movie.dart';

class DetailsScreen extends StatefulWidget {
  final Movie movie;

  const DetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool _isPlotExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: widget.movie.id,
              child: Image.asset(
                widget.movie.poster,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.movie.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '${widget.movie.year} | ${widget.movie.genre.join(', ')}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: <Widget>[
                      const Icon(Icons.star, color: Colors.amber),
                      Text('${widget.movie.rating}/10'),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Plot Summary',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    widget.movie.plot,
                    maxLines: _isPlotExpanded ? 100 : 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.movie.plot.length > 100)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isPlotExpanded = !_isPlotExpanded;
                        });
                      },
                      child: Text(_isPlotExpanded ? 'See Less' : 'See More'),
                    ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Cast',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.movie.cast.length,
                      itemBuilder: (context, index) {
                        final actor = widget.movie.cast[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  actor['image']!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(actor['originalName']!),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
