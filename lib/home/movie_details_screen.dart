import 'package:flutter/material.dart';
import 'package:movies/app_colors.dart';
import 'package:movies/api/api_manger.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> movie;

  MovieDetailsScreen({required this.movie});

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Future<Map<String, dynamic>?> _similarMoviesFuture;
  late Future<Map<String, dynamic>?> _movieImagesFuture;

  @override
  void initState() {
    super.initState();
    _similarMoviesFuture =
        ApiManager().getSimilarMovies(widget.movie['id'].toString());
    _movieImagesFuture =
        ApiManager().getMovieImages(widget.movie['id'].toString());
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster
            Center(
              child: Image.network(
                'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                height: 300.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),

            // Movie Details and Images Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: FutureBuilder<Map<String, dynamic>?>(
                    future: _movieImagesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData) {
                        var movieImages =
                            snapshot.data?['backdrops'] as List<dynamic>?;

                        if (movieImages == null || movieImages.isEmpty) {
                          return Center(child: Text('No images available.'));
                        }

                        return Container(
                          height: 200.0, // Adjust height as needed
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: movieImages.length,
                            itemBuilder: (context, index) {
                              var image = movieImages[index];
                              return Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${image['file_path']}',
                                  fit: BoxFit.cover,
                                  width: 150.0, // Adjust width as needed
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(
                            child: Text('No movie images available.'));
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Movie Title
                        Text(
                          movie['title'] ?? 'No title available',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        SizedBox(height: 8.0),

                        // Movie Rating
                        Text(
                          'Rating: ${movie['vote_average']}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        SizedBox(height: 8.0),

                        // Release Date
                        Text(
                          'Release Date: ${movie['release_date']}',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        SizedBox(height: 16.0),

                        // Overview
                        Text(
                          movie['overview'] ?? 'No overview available.',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Similar Movies
            FutureBuilder<Map<String, dynamic>?>(
              future: _similarMoviesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  var similarMovies =
                      snapshot.data?['results'] as List<dynamic>?;

                  if (similarMovies == null || similarMovies.isEmpty) {
                    return Center(child: Text('No similar movies found.'));
                  }

                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Similar Movies',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        SizedBox(
                          height: 200.0,
                          child: CarouselSlider.builder(
                            itemCount: similarMovies.length,
                            itemBuilder: (context, index, realIndex) {
                              var movie = similarMovies[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MovieDetailsScreen(movie: movie),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          color: Colors.black.withOpacity(0.5),
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            movie['title'] ??
                                                'No title available',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.whiteColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: 200.0,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text('No similar movies available.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
