import 'package:flutter/material.dart';
import 'package:movies/api/api_manger.dart';
import 'package:movies/tabs/category_movies_screen.dart';

class CategoryTab extends StatefulWidget {
  @override
  _CategoryTabState createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  late Future<List<Map<String, dynamic>>?> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = fetchCategories();
  }

  Future<List<Map<String, dynamic>>?> fetchCategories() async {
    var response = await ApiManager().getCategories();

    if (response != null && response['genres'] != null) {
      List<dynamic> genres = response['genres'];
      return genres.map((genre) => genre as Map<String, dynamic>).toList();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>?>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No categories available.'));
        } else {
          final categories = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final genre = categories[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MoviesByCategoryScreen(
                        genreId: genre['id'],
                        genreName: genre['name'] ?? 'Unknown Genre',
                      ),
                    ),
                  );
                },
                child: CategoryCard(
                  genreName: genre['name'] ?? 'Unknown Genre',
                ),
              );
            },
          );
        }
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String genreName;

  CategoryCard({required this.genreName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                'assets/images/film.png',
                fit: BoxFit.cover, // Cover the entire area of the grid cell
                width: double.infinity, // Make the image take the full width of the cell
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              genreName,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


