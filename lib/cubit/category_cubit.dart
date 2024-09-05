import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movies/api/api_manger.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  Future<void> fetchCategories() async {
    emit(CategoryLoading());
    try {
      final response = await ApiManager().getCategories();
      if (response != null && response['genres'] != null) {
        List<dynamic> genres = response['genres'];
        emit(CategoryLoaded(
          genres.map((genre) => genre as Map<String, dynamic>).toList(),
        ));
      } else {
        emit(CategoryLoaded([]));
      }
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
