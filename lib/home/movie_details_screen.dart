import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/app_colors.dart';
import 'package:movies/cubit/movie_images_cubit.dart';
import 'package:movies/cubit/similar_movies_cubit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'home_screen.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> movie;

  MovieDetailsScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              SimilarMoviesCubit()..fetchSimilarMovies(movie['id'].toString()),
        ),
        BlocProvider(
          create: (context) =>
              MovieImagesCubit()..fetchMovieImages(movie['id'].toString()),
        ),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.whiteColor),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                    ),
                    Text(
                      'Back to movies',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                  height: 300.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: BlocBuilder<MovieImagesCubit, MovieImagesState>(
                      builder: (context, state) {
                        if (state is MovieImagesLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is MovieImagesError) {
                          return Center(child: Text('Error: ${state.message}'));
                        } else if (state is MovieImagesLoaded) {
                          var movieImages =
                              state.images['backdrops'] as List<dynamic>?;

                          if (movieImages == null || movieImages.isEmpty) {
                            return Center(child: Text('No images available.'));
                          }
                          return Container(
                            height: 200.0,
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
                                    width: 150.0,
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
                          Text(
                            movie['title'] ?? 'No title available',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Rating: ${movie['vote_average']}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Release Date: ${movie['release_date']}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          SizedBox(height: 16.0),
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
              BlocBuilder<SimilarMoviesCubit, SimilarMoviesState>(
                builder: (context, state) {
                  if (state is SimilarMoviesLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is SimilarMoviesError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else if (state is SimilarMoviesLoaded) {
                    var similarMovies =
                        state.movies['results'] as List<dynamic>?;

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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 5.0),
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
                                            color:
                                                Colors.black.withOpacity(0.5),
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
                                height: 150.0,
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
      ),
    );
  }
}
