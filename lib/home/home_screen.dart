import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movies/api/api_manger.dart';
import 'package:movies/cubit/home_cubit.dart';
import 'package:movies/cubit/search_cubit.dart';
import 'package:movies/home/movie_details_screen.dart';
import 'package:movies/app_colors.dart';
import 'package:movies/tabs/category_tab.dart';
import 'package:movies/tabs/search_tab.dart';
import 'package:movies/tabs/watchlist_tab.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..loadMovies(),
      child: Scaffold(
        backgroundColor: AppColors.blackColor,
        bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return BottomNavigationBar(
              currentIndex: state.currentTab.index,
              onTap: (index) {
                final cubit = context.read<HomeCubit>();
                cubit.setTab(HomeTab.values[index]);
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
            );
          },
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            switch (state.currentTab) {
              case HomeTab.home:
                return _buildHomeScreen(context, state);
              case HomeTab.search:
                return BlocProvider(
                  create: (context) => SearchCubit(ApiManager()),
                  child: SearchTab(),
                );
              case HomeTab.browse:
                return CategoryTab();
              case HomeTab.watchlist:
                return WatchlistTab();
              default:
                return Center(child: Text('No screen selected'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildHomeScreen(BuildContext context, HomeState state) {
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state.error != null) {
      return Center(child: Text('Error: ${state.error}'));
    } else if (state.upcomingMovies == null || state.topRatedMovies == null) {
      return Center(child: Text('No data available.'));
    } else {
      var upcomingMovies = state.upcomingMovies?['results'] as List<dynamic>?;
      var topRatedMovies = state.topRatedMovies?['results'] as List<dynamic>?;

      return SingleChildScrollView(
        child: Column(
          children: [
            _buildCarouselSlider(upcomingMovies, context),
            _buildUpcomingMovies(upcomingMovies),
            _buildTopRatedMovies(topRatedMovies),
          ],
        ),
      );
    }
  }

  Widget _buildCarouselSlider(List<dynamic>? movies, BuildContext context) {
    if (movies == null || movies.isEmpty) {
      return Center(child: Text('No upcoming movies found.'));
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        height: 300.0,
        child: CarouselSlider.builder(
          itemCount: movies.length,
          itemBuilder: (context, index, realIndex) {
            var movie = movies[index];
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
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 8.0),
                                  width: 50.0,
                                  height: 75.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie['title'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.whiteColor,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      RatingBar.builder(
                                        initialRating:
                                            movie['vote_average'] / 2,
                                        minRating: 1,
                                        itemSize: 20.0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
    );
  }

  Widget _buildUpcomingMovies(List<dynamic>? movies) {
    if (movies == null || movies.isEmpty) {
      return Center(child: Text('No upcoming movies found.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Upcoming Movies',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColor,
            ),
          ),
        ),
        SizedBox(
          height: 200.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              var movie = movies[index];
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
                  child: Column(
                    children: [
                      Image.network(
                        'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                        fit: BoxFit.cover,
                        height: 140.0,
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        movie['title'],
                        style: TextStyle(
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopRatedMovies(List<dynamic>? movies) {
    if (movies == null || movies.isEmpty) {
      return Center(child: Text('No top-rated movies found.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Top Rated Movies',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: AppColors.whiteColor,
            ),
          ),
        ),
        SizedBox(
          height: 200.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              var movie = movies[index];
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                        fit: BoxFit.cover,
                        height: 150.0,
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        movie['title'],
                        style: TextStyle(
                          color: AppColors.whiteColor,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      RatingBar.builder(
                        initialRating: movie['vote_average'] / 2,
                        minRating: 1,
                        itemSize: 20.0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
