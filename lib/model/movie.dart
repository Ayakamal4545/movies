class Movie {
  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.releaseDate,
  });

  Movie.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        overview = json['overview'],
        posterPath = json['poster_path'],
        releaseDate = json['release_date'];

  final int id;
  final String title;
  final String overview;
  final String? posterPath; // Optional field
  final String? releaseDate; // Optional field

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'release_date': releaseDate,
    };
  }
}
