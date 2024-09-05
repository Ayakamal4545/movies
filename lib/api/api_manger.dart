import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movies/api/api_constants.dart';
import 'package:movies/model/movie.dart';


class ApiManager {
  Future<Map<String, dynamic>?> getPopular() async {
    return await _getMovies(ApiConstants.popularSourceApi);
  }

  Future<Map<String, dynamic>?> getTopRated() async {
    return await _getMovies(ApiConstants.topRatedSourceApi);
  }

  Future<Map<String, dynamic>?> getUpcoming() async {
    return await _getMovies(ApiConstants.upComingSourceApi);
  }

  Future<Map<String, dynamic>?> _getMovies(String apiPath) async {
    try {
      Uri url = Uri.https(ApiConstants.baseUrl, apiPath, {
        'api_key': ApiConstants.apiKey,
      });

      http.Response response = await http.get(
          url, headers: ApiConstants.headers);

      if (response.statusCode == 200) {
        String data = response.body;
        var jsonData = jsonDecode(data);
        return jsonData;
      } else {
        print('Failed to load movies: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching movies: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchMovieDetails(String movieId) async {
    if (movieId.isEmpty) {
      print('Movie ID is empty');
      return null;
    }

    try {
      ApiManager apiManager = ApiManager();
      var movieDetails = await apiManager._getMovies('/3/movie/$movieId');

      if (movieDetails != null) {
        print('Movie Details: $movieDetails');
        return movieDetails;
      } else {
        print('Failed to fetch movie details');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching movie details: $e');
      return null;
    }
  }


  Future<Map<String, dynamic>?> getMovieImages(String movieId) async {
    if (movieId.isEmpty) {
      print('Movie ID is empty');
      return null;
    }

    Uri url = Uri.https(ApiConstants.baseUrl, '/3/movie/$movieId/images', {
      'api_key': ApiConstants.apiKey,
    });

    try {
      final response = await http.get(url, headers: ApiConstants.headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to load movie images: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching movie images: $e');
      return null;
    }
  }


  Future<Map<String, dynamic>?> getSimilarMovies(String movieId) async {
    if (movieId.isEmpty) {
      print('Movie ID is empty');
      return null;
    }

    Uri url = Uri.https(ApiConstants.baseUrl,
        ApiConstants.similerSourceApi.replaceFirst('movie_id', movieId), {
          'api_key': ApiConstants.apiKey,
        });

    print('Constructed URL: $url');

    try {
      final response = await http.get(url, headers: ApiConstants.headers);
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        return jsonDecode(response.body);
      } else {
        return _handleHttpError(response);
      }
    } on FormatException catch (e) {
      print('Format error: $e');
      return null;
    } on SocketException catch (e) {
      print('Network error: $e');
      return null;
    } catch (e) {
      print('General error: $e');
      return null;
    }
  }

  Map<String, dynamic>? _handleHttpError(http.Response response) {
    switch (response.statusCode) {
      case 401:
        print('Unauthorized: Check your API key.');
        break;
      case 404:
        print('Not Found: The requested resource could not be found.');
        break;
      case 429:
        print('Too Many Requests: Rate limit exceeded.');
        break;
      case 500:
      case 502:
      case 503:
      case 504:
        print('Server error: Try again later.');
        break;
      default:
        print('Failed to load similar movies. Status code: ${response.statusCode}');
        break;
    }
    return null;
  }


  Future<Map<String, dynamic>?> getCategories() async {
    try {
      Uri url = Uri.https(ApiConstants.baseUrl, ApiConstants.categoryApi, {
        'api_key': ApiConstants.apiKey,
      });

      http.Response response = await http.get(
          url, headers: ApiConstants.headers);

      if (response.statusCode == 200) {
        String data = response.body;
        var jsonData = jsonDecode(data);
        return jsonData;
      } else {
        print('Failed to load categories: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error occurred while fetching categories: $e');
      return null;
    }
  }


  Future<Map<String, dynamic>?> getMoviesByGenre(int? genreId) async {
    if (genreId == null) {
      print('Genre ID is null');
      return null;
    }

    Uri url = Uri.https(ApiConstants.baseUrl, ApiConstants.discoverApi, {
      'api_key': ApiConstants.apiKey,
      'with_genres': genreId.toString(),
    });

    print('Constructed URL: $url');

    try {
      final response = await http.get(url);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Check your API key.');
      } else if (response.statusCode == 404) {
        throw Exception(
            'Not Found: The requested resource could not be found.');
      } else if (response.statusCode == 429) {
        throw Exception('Too Many Requests: Rate limit exceeded.');
      } else if (response.statusCode >= 500) {
        throw Exception('Server error: Try again later.');
      } else {
        throw Exception('Failed to load movies by genre. Status code: ${response
            .statusCode}');
      }
    } on FormatException catch (e) {
      print('Format error: $e');
      rethrow;
    } on SocketException catch (e) {
      print('Network error: $e');
      rethrow;
    } catch (e) {
      print('General error: $e');
      rethrow;
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(
      ApiConstants.baseUrl,
      ApiConstants.searchApi,
      {
        'api_key': ApiConstants.apiKey,
        'query': query,
      },
    );

    final response = await http.get(url, headers: ApiConstants.headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      return results.map((item) => Movie.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
}
}