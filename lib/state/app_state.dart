import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:movie/models/movie.dart';

class AppState extends ChangeNotifier {
  final Set<int> _favoriteMovieIds = <int>{};
  int _selectedCategoryIndex = 0; // 0: In Theater, 1: Box Office, 2: Coming Soon

  Set<int> get favoriteMovieIds => _favoriteMovieIds;
  int get selectedCategoryIndex => _selectedCategoryIndex;

  bool isFavorite(Movie movie) => _favoriteMovieIds.contains(movie.id);

  void toggleFavorite(Movie movie) {
    if (_favoriteMovieIds.contains(movie.id)) {
      _favoriteMovieIds.remove(movie.id);
    } else {
      _favoriteMovieIds.add(movie.id);
    }
    notifyListeners();
  }

  void setSelectedCategoryIndex(int index) {
    if (_selectedCategoryIndex == index) return;
    _selectedCategoryIndex = index;
    notifyListeners();
  }

  List<Movie> getFilteredMovies(List<Movie> allMovies) {
    switch (_selectedCategoryIndex) {
      case 0: // In Theater: recent movies (year >= 2020)
        return allMovies.where((m) => m.year >= 2020).toList();
      case 1: // Box Office: high rating
        return allMovies.where((m) => m.rating >= 8.0).toList();
      case 2: // Coming Soon: future or latest year
        final int currentYear = DateTime.now().year;
        final int threshold = currentYear; // treat current year as coming soon for demo
        final List<Movie> upcoming = allMovies.where((m) => m.year >= threshold).toList();
        if (upcoming.isNotEmpty) return upcoming;
        // fallback: latest year available
        final int latestYear = allMovies.map((m) => m.year).fold<int>(0, (p, e) => e > p ? e : p);
        return allMovies.where((m) => m.year == latestYear).toList();
      default:
        return allMovies;
    }
  }

  List<Movie> get favoriteMovies => movies.where((m) => _favoriteMovieIds.contains(m.id)).toList();
}

class AppStateWidget extends InheritedNotifier<AppState> {
  AppStateWidget({Key? key, required Widget child})
      : super(key: key, notifier: AppState(), child: child);

  static AppState of(BuildContext context) {
    final AppStateWidget? provider = context.dependOnInheritedWidgetOfExactType<AppStateWidget>();
    assert(provider != null, 'AppStateWidget not found in context');
    return provider!.notifier!;
  }
}


