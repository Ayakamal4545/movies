import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/cubit/movies_by_category_cubit.dart';

class MoviesByCategoryScreen extends StatelessWidget {
  final int genreId;
  final String genreName;

  MoviesByCategoryScreen({required this.genreId, required this.genreName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoviesByCategoryCubit()..fetchMoviesByCategory(genreId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Movies in $genreName'),
        ),
        body: BlocBuilder<MoviesByCategoryCubit, MoviesByCategoryState>(
          builder: (context, state) {
            if (state is MoviesByCategoryLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MoviesByCategoryError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is MoviesByCategoryLoaded) {
              final movies = state.movies['results'] as List<dynamic>;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return MovieCard(movie: movie);
                },
              );
            } else {
              return Center(child: Text('No movies available.'));
            }
          },
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Map<String, dynamic> movie;

  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movie['title'] ?? 'No Title',
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
