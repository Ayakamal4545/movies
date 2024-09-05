import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movies/api/api_manger.dart';

part 'movies_by_category_state.dart';

class MoviesByCategoryCubit extends Cubit<MoviesByCategoryState> {
  MoviesByCategoryCubit() : super(MoviesByCategoryInitial());

  Future<void> fetchMoviesByCategory(int genreId) async {
    emit(MoviesByCategoryLoading());
    try {
      final movies = await ApiManager().getMoviesByGenre(genreId);
      emit(MoviesByCategoryLoaded(movies!));
    } catch (e) {
      emit(MoviesByCategoryError(e.toString()));
    }
  }
}
