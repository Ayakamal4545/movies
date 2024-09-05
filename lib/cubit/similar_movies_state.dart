part of 'similar_movies_cubit.dart';

@immutable
abstract class SimilarMoviesState {}

class SimilarMoviesInitial extends SimilarMoviesState {}

class SimilarMoviesLoading extends SimilarMoviesState {}

class SimilarMoviesLoaded extends SimilarMoviesState {
  final Map<String, dynamic> movies;
  SimilarMoviesLoaded(this.movies);
}

class SimilarMoviesError extends SimilarMoviesState {
  final String message;
  SimilarMoviesError(this.message);
}
