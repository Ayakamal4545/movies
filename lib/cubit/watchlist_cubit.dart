import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movies/model/movie.dart';

part 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  WatchlistCubit() : super(WatchlistInitial()) {
    fetchWatchlist();
  }

  void fetchWatchlist() {
    emit(WatchlistLoading());
    _firebaseFirestore.collection('watchlist').snapshots().listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        emit(WatchlistEmpty());
      } else {
        final movies = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Movie.fromJson(data);
        }).toList();
        emit(WatchlistLoaded(movies: movies));
      }
    }).onError((error) {
      emit(WatchlistError(error.toString()));
    });
  }
}
