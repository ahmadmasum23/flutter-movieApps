import 'package:flutter/material.dart';
import '../models/film.dart';

class DetailPage extends StatelessWidget {
  final Film film;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  DetailPage({
    required this.film,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(film.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
            onPressed: onFavoriteToggle,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(film.poster, height: 250),
            ),
            SizedBox(height: 16),
            Text(film.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Tahun: ${film.year}'),
            SizedBox(height: 8),
            Text('Genre: ${film.genre}'),
            SizedBox(height: 16),
            Text('Sinopsis:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(film.synopsis),
          ],
        ),
      ),
    );
  }
}
  