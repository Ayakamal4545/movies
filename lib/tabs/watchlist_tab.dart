import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/cubit/watchlist_cubit.dart';
import 'package:movies/app_colors.dart';

class WatchlistTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watchlist')),
      body: BlocBuilder<WatchlistCubit, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is WatchlistError) {
            return Center(child: Text('An error occurred: ${state.message}'));
          } else if (state is WatchlistEmpty) {
            return Center(child: Text('No movies in watchlist'));
          } else if (state is WatchlistLoaded) {
            final movies = state.movies;

            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                final imageUrl = movie.posterPath != null
                    ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                    : 'https://via.placeholder.com/150';
                return ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  leading: Image.network(
                    imageUrl,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(movie.title, style: TextStyle(color: AppColors.whiteColor)),
                  subtitle: Text(movie.releaseDate ?? 'No release date', style: TextStyle(color: AppColors.whiteColor)),
                );
              },
            );
          } else {
            return Center(child: Text('Unexpected state'));
          }
        },
      ),
    );
  }
}
