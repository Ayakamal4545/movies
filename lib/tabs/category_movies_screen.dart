import 'package:flutter/material.dart';
import 'package:movies/api/api_manger.dart';

class MoviesByCategoryScreen extends StatelessWidget {
  final int genreId;
  final String genreName;

  MoviesByCategoryScreen({required this.genreId, required this.genreName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies in $genreName'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: ApiManager().getMoviesByGenre(genreId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No movies available.'));
          } else {
            final movies = snapshot.data!['results'] as List<dynamic>;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // Display one movie per row
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieCard(movie: movie);
              },
            );
          }
        },
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
          Container(
            width: double.infinity, // Make the image take the full width of the row
            height: 350, // Set a fixed height for the image
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
              fit: BoxFit.cover, // Cover the entire area, cropping if necessary
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
