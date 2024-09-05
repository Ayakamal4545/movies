import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies/app_colors.dart';

class WatchlistTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watchlist')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('watchlist').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var movie = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                var imageUrl = movie['posterPath'] != null
                    ? 'https://image.tmdb.org/t/p/w500${movie['posterPath']}'
                    : 'https://via.placeholder.com/150';
                return ListTile(
                  leading: Image.network(imageUrl, width: 50, fit: BoxFit.cover),
                  title: Text(movie['title'] ?? 'No Title',),
                  subtitle: Text(movie['releaseDate'] ?? 'No Release Date'),
                );
              },
            );
          } else {
            return Center(child: Text('No movies in watchlist'));
          }
        },
      ),
    );
  }
}
