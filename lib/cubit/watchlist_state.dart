part of 'watchlist_cubit.dart';  // Ensure this is correctly specified

abstract class WatchlistState {}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<Movie> movies;

  WatchlistLoaded({required this.movies});
}

class WatchlistEmpty extends WatchlistState {}

class WatchlistError extends WatchlistState {
  final String message;

  WatchlistError(this.message);
}
