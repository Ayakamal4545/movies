part of 'movies_by_category_cubit.dart';

@immutable
abstract class MoviesByCategoryState {}

class MoviesByCategoryInitial extends MoviesByCategoryState {}

class MoviesByCategoryLoading extends MoviesByCategoryState {}

class MoviesByCategoryLoaded extends MoviesByCategoryState {
  final Map<String, dynamic> movies;
  MoviesByCategoryLoaded(this.movies);
}

class MoviesByCategoryError extends MoviesByCategoryState {
  final String message;
  MoviesByCategoryError(this.message);
}
