import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movies/api/api_manger.dart';

part 'movie_images_state.dart';

class MovieImagesCubit extends Cubit<MovieImagesState> {
  MovieImagesCubit() : super(MovieImagesInitial());

  Future<void> fetchMovieImages(String movieId) async {
    emit(MovieImagesLoading());
    try {
      final images = await ApiManager().getMovieImages(movieId);
      emit(MovieImagesLoaded(images!));
    } catch (e) {
      emit(MovieImagesError(e.toString()));
    }
  }
}
