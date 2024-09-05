class ApiConstants{
  static const String apiKey = '0343914cc32b3eafbf1b3565eda3e6e4';
  static const String authorization =
      'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwMzQzOTE0Y2MzMmIzZWFmYmYxYjM1NjVlZGEzZTZlNCIsIm5iZiI6MTcyNTAyODYzMi43OTkzNzYsInN1YiI6IjY2ZDFkMzhiYTc3ZmE1OWRmNDZhNTU5YyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.PPpDhYB7qPr13mV2Xn6U7OV4NCs03U6mPnu2TKkpTOs';
static const String movieId="";
  static const Map<String, String> headers = {
    'Authorization': authorization,
    'Accept': 'application/json',
  };

  static const String baseUrl='api.themoviedb.org';
  static const String popularSourceApi='/3/movie/popular';
  static const String upComingSourceApi='/3/movie/upcoming';
  static const String topRatedSourceApi='/3/movie/top_rated';
  static const String detailsSourceApi='/3/movie/$movieId';
  static const String similerSourceApi='/3/movie/movie_id/similar';
  static const String categoryApi='/3/genre/movie/list';
  static const String discoverApi='/3/discover/movie';
  static const String searchApi='/3/search/movie';
}