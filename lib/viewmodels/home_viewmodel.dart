import 'package:flutter/material.dart';
import 'package:movie/models/movie.dart';

class HomeViewModel extends ChangeNotifier {
  String _searchQuery = '';
  int _selectedCategoryIndex = 0;

  final List<String> categories = ['Now Playing', 'Top Rated', 'Upcoming'];

  List<Movie> get movieList {
    List<Movie> filteredMovies = movies;

    // In a real app, you would filter based on the category.
    // For this example, we'll just use the same list for all categories.

    if (_searchQuery.isNotEmpty) {
      filteredMovies = filteredMovies
          .where((movie) =>
              movie.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filteredMovies;
  }

  int get selectedCategoryIndex => _selectedCategoryIndex;

  void selectCategory(int index) {
    _selectedCategoryIndex = index;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
