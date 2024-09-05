import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movies/api/api_manger.dart';

part 'similar_movies_state.dart';

class SimilarMoviesCubit extends Cubit<SimilarMoviesState> {
  SimilarMoviesCubit() : super(SimilarMoviesInitial());

  Future<void> fetchSimilarMovies(String movieId) async {
    emit(SimilarMoviesLoading());
    try {
      final movies = await ApiManager().getSimilarMovies(movieId);
      emit(SimilarMoviesLoaded(movies!));
    } catch (e) {
      emit(SimilarMoviesError(e.toString()));
    }
  }
}
