import 'package:cat_app/features/cats/model/cat_model.dart';

abstract class CatState {}

class CatEmptyState extends CatState {}

class CatLoadingState extends CatState {}

class CatLoadedState extends CatState {
  List<CatModel> catsList;
  int catsPage;

  List<CatModel> favoritesList;
  int favoritesPage;

  CatLoadedState({
    required this.catsList,
    required this.favoritesList,
    this.catsPage = 1,
    this.favoritesPage = 0,
  });
}

class CatErrorState extends CatState {
  String message;
  CatErrorState({this.message = 'Error!'});
}
