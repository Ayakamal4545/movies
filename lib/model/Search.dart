import 'package:movies/model/movie.dart';

class Search {
  Search({
    this.page,
    List<Movie>? results,
    this.totalPages,
    this.totalResults,
  }) {
    this.results = results ?? []; // Initialize in the constructor
  }

  Search.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    results = [];
    if (json['results'] != null) {
      json['results'].forEach((v) {
        results.add(Movie.fromJson(v));
      });
    }
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  int? page;
  late List<Movie> results; // Marked as late
  int? totalPages;
  int? totalResults;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['results'] = results.map((v) => v.toJson()).toList();
    map['total_pages'] = totalPages;
    map['total_results'] = totalResults;
    return map;
  }
}
