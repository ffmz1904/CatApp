import 'package:cat_app/bloc/cat/cat_state.dart';
import 'package:cat_app/models/cat_model.dart';

class FavoriteCatEmptyState extends CatState {}

class FavoriteCatLoadingState extends CatState {}

class FavoriteCatLoadedState extends CatState {
  List<CatModel> catList;
  int page;

  FavoriteCatLoadedState({required this.catList, this.page = 0});
}

class FavoriteCatErrorState extends CatState {}
