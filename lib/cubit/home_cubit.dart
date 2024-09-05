import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:movies/api/api_manger.dart';

enum HomeTab { home, search, browse, watchlist }

class HomeState {
  final HomeTab currentTab;
  final Map<String, dynamic>? upcomingMovies;
  final Map<String, dynamic>? topRatedMovies;
  final bool isLoading;
  final String? error;

  HomeState({
    required this.currentTab,
    this.upcomingMovies,
    this.topRatedMovies,
    this.isLoading = false,
    this.error,
  });

  HomeState copyWith({
    HomeTab? currentTab,
    Map<String, dynamic>? upcomingMovies,
    Map<String, dynamic>? topRatedMovies,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      currentTab: currentTab ?? this.currentTab,
      upcomingMovies: upcomingMovies ?? this.upcomingMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(currentTab: HomeTab.home));

  void setTab(HomeTab tab) {
    emit(state.copyWith(currentTab: tab));
  }

  void loadMovies() async {
    emit(state.copyWith(isLoading: true));
    try {
      final upcoming = await ApiManager().getUpcoming();
      final topRated = await ApiManager().getTopRated();
      emit(state.copyWith(
        upcomingMovies: upcoming,
        topRatedMovies: topRated,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
