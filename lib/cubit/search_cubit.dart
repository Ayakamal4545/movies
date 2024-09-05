import 'package:bloc/bloc.dart';
import 'package:movies/api/api_manger.dart';
import 'package:movies/cubit/search_state.dart';
import 'package:movies/model/movie.dart';

class SearchCubit extends Cubit<SearchState> {
  final ApiManager apiManager;

  SearchCubit(this.apiManager) : super(SearchInitial());

  void searchMovies(String query) async {
    emit(SearchLoading());
    try {
      final results = await apiManager.searchMovies(query);
      emit(SearchLoaded(results));
    } catch (e) {
      emit(SearchError('Failed to load movies'));
    }
  }
}
