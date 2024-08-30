import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies/home/movie_details_screen.dart';
import 'package:movies/api/api_manger.dart';
import 'package:movies/app_colors.dart';
import 'package:movies/tabs/category_tab.dart';


class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of screens
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _buildHomeScreen(),
      Center(child: Text('Search Screen')),
      CategoryTab(),
      Center(child: Text('Watchlist Screen')),
    ];
  }

  Widget _buildHomeScreen() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: ApiManager().getUpcoming(),
      builder: (context, upcomingSnapshot) {
        if (upcomingSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (upcomingSnapshot.hasError) {
          return Center(child: Text('Error: ${upcomingSnapshot.error}'));
        } else if (upcomingSnapshot.hasData) {
          var upcomingMovies = upcomingSnapshot.data?['results'] as List<dynamic>?;

          if (upcomingMovies == null || upcomingMovies.isEmpty) {
            return Center(child: Text('No upcoming movies found.'));
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    height: 300.0,
                    child: CarouselSlider.builder(
                      itemCount: upcomingMovies.length,
                      itemBuilder: (context, index, realIndex) {
                        var movie = upcomingMovies[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailsScreen(movie: movie),
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
                                  height: 300.0,
                                ),
                                Positioned(
                                  left: 10,
                                  top: 10,
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Container(
                                      width: 60.0,
                                      height: 60.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.black.withOpacity(0.5),
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          movie['title'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.whiteColor,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        Text(
                                          'Rating: ${movie['vote_average']}',
                                          style: TextStyle(
                                            color: AppColors.whiteColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 300.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.8,
                      ),
                    ),
                  ),
                ),
                _buildUpcomingMovies(),
                _buildTopRatedMovies(),
              ],
            ),
          );
        } else {
          return Center(child: Text('No data available.'));
        }
      },
    );
  }

  Widget _buildUpcomingMovies() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: ApiManager().getUpcoming(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          var movies = snapshot.data?['results'] as List<dynamic>?;

          if (movies == null || movies.isEmpty) {
            return Center(child: Text('No upcoming movies found.'));
          }

          return Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'New Released',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 200.0,
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      var movie = movies[index];
                      return Container(
                        width: 140.0, // Fixed width for each item
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Minimize vertical size
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              movie['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                color: AppColors.whiteColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Rating: ${movie['vote_average']}',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: AppColors.whiteColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No data available.'));
        }
      },
    );
  }

  Widget _buildTopRatedMovies() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: ApiManager().getTopRated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          var movies = snapshot.data?['results'] as List<dynamic>?;

          if (movies == null || movies.isEmpty) {
            return Center(child: Text('No top-rated movies found.'));
          }

          return Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Recommended',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(
                  height: 200.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      var movie = movies[index];
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                width: 120.0,
                                height: 180.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              movie['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Rating: ${movie['vote_average']}',
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No data available.'));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Browse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Watchlist',
          ),
        ],
      ),
      body: _screens[_currentIndex], // Use _screens[_currentIndex] here
    );
  }
}