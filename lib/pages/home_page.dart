import 'package:flutter/material.dart';
import '../models/film.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Film> films = [
    Film(
      title: 'Inception',
      year: '2010',
      genre: 'Sci-Fi, Thriller',
      synopsis: 'Seorang pencuri yang bisa memasuki mimpi orang lain...',
      poster: 'https://upload.wikimedia.org/wikipedia/en/7/7f/Inception_ver3.jpg',
    ),
    Film(
      title: 'The Dark Knight',
      year: '2008',
      genre: 'Action, Crime',
      synopsis: 'Batman menghadapi Joker yang kejam di Gotham City...',
      poster: 'https://upload.wikimedia.org/wikipedia/en/8/8a/Dark_Knight.jpg',
    ),
    Film(
      title: 'Interstellar',
      year: '2014',
      genre: 'Sci-Fi, Adventure',
      synopsis: 'Sekelompok astronot menjelajahi lubang cacing untuk menyelamatkan umat manusia...',
      poster: 'https://upload.wikimedia.org/wikipedia/en/b/bc/Interstellar_film_poster.jpg',
    ),
    Film(
      title: 'Avengers: Endgame',
      year: '2019',
      genre: 'Action, Adventure',
      synopsis: 'Para pahlawan super mencoba mengembalikan keseimbangan alam semesta...',
      poster: 'https://upload.wikimedia.org/wikipedia/en/0/0d/Avengers_Endgame_poster.jpg',
    ),
    Film(
      title: 'Parasite',
      year: '2019',
      genre: 'Thriller, Drama',
      synopsis: 'Kisah dua keluarga dari kelas sosial berbeda bertemu dengan cara mengejutkan...',
      poster: 'https://upload.wikimedia.org/wikipedia/en/5/53/Parasite_%282019_film%29.png',
    ),
  ];

  final List<Film> favoriteFilms = [];

  void toggleFavorite(Film film) {
    setState(() {
      if (favoriteFilms.contains(film)) {
        favoriteFilms.remove(film);
      } else {
        favoriteFilms.add(film);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Film'),
      ),
      body: ListView.builder(
        itemCount: films.length,
        itemBuilder: (context, index) {
          final film = films[index];
          final isFavorite = favoriteFilms.contains(film);

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Image.network(film.poster, width: 50, fit: BoxFit.cover),
              title: Text(film.title),
              subtitle: Text(film.year),
              trailing: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () => toggleFavorite(film),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(
                      film: film,
                      isFavorite: isFavorite,
                      onFavoriteToggle: () => toggleFavorite(film),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
