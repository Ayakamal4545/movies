import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/cubit/category_cubit.dart';
import 'package:movies/tabs/category_movies_screen.dart';

class CategoryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryCubit()..fetchCategories(),
      child: Scaffold(
        body: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CategoryError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is CategoryLoaded) {
              final categories = state.categories;
              if (categories.isEmpty) {
                return Center(child: Text('No categories available.'));
              }
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
            } else {
              return Center(child: Text('No categories available.'));
            }
          },
        ),
      ),
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
                fit: BoxFit.cover,
                width: double.infinity,
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
