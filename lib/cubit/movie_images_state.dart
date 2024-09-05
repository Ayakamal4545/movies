part of 'movie_images_cubit.dart';

@immutable
abstract class MovieImagesState {}

class MovieImagesInitial extends MovieImagesState {}

class MovieImagesLoading extends MovieImagesState {}

class MovieImagesLoaded extends MovieImagesState {
  final Map<String, dynamic> images;
  MovieImagesLoaded(this.images);
}

class MovieImagesError extends MovieImagesState {
  final String message;
  MovieImagesError(this.message);
}
