import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies/api/api_manger.dart';
import 'package:movies/app_colors.dart';
import 'package:movies/model/movie.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchTab> {
  final TextEditingController _controller = TextEditingController();
  final ApiManager _apiManager = ApiManager();
  List<Movie>? _searchResults;
  Timer? _debounce;

  void _search(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    try {
      final results = await _apiManager.searchMovies(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _search(query);
    });
  }

  void _addToWatchlist(Map<String, dynamic> movie) async {
    print('Adding movie to watchlist: $movie');
    try {
      await FirebaseFirestore.instance.collection('watchlist').add(movie);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Movie added to watchlist!')),
      );
    } catch (e) {
      print('Failed to add movie: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add movie to watchlist.')),
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Movies')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                label: Text('Search',
                    style: TextStyle(color: AppColors.whiteColor)),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: _searchResults == null || _searchResults!.isEmpty
                ? Center(
                    child: Text('No results',
                        style: TextStyle(color: AppColors.whiteColor)))
                : ListView.builder(
                    itemCount: _searchResults!.length,
                    itemBuilder: (context, index) {
                      final movie = _searchResults![index];
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
                        title: Text(movie.title ?? 'No Title',
                            style: TextStyle(color: AppColors.whiteColor)),
                        subtitle: Text(movie.releaseDate ?? 'No Release Date',
                            style: TextStyle(color: AppColors.whiteColor)),
                        trailing: IconButton(
                          icon: Icon(Icons.add, color: AppColors.whiteColor),
                          onPressed: () {
                            _addToWatchlist(movie.toJson());
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
