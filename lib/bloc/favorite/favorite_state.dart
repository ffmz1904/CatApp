import 'package:cat_app/models/cat_model.dart';

abstract class FavoriteState {}

class FavoriteEmptyState extends FavoriteState {}

class FavoriteLoadingState extends FavoriteState {}

class FavoriteLoadedState extends FavoriteState {
  List<Cat> cats;
  int page;

  FavoriteLoadedState({required this.cats, this.page = 1});
}

class FavoriteErrorState extends FavoriteState {}
