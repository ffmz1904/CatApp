import 'package:cat_app/features/cats/model/cat_model.dart';

abstract class CatState {
  CatModel getCatData(final CatModel cat) {
    return CatModel(
      id: cat.id,
      image: cat.image,
      fact: cat.fact,
      isFavorite: false,
    );
  }
}

class CatEmptyState extends CatState {}

class CatLoadingState extends CatState {}

class CatLoadedState extends CatState {
  final List<CatModel> catsList;
  final int catsPage;

  final List<CatModel> favoritesList;
  final int favoritesPage;

  CatLoadedState({
    required this.catsList,
    required this.favoritesList,
    this.catsPage = 1,
    this.favoritesPage = 0,
  });

  @override
  CatModel getCatData(final CatModel cat) {
    CatModel catData;

    final findInFavorite = favoritesList.where((c) => c.id == cat.id).toList();

    if (findInFavorite.isNotEmpty) {
      catData = findInFavorite.first;
      return catData;
    }

    final findInCommon = catsList.where((c) => c.id == cat.id).toList();

    if (findInCommon.isNotEmpty) {
      catData = findInCommon.first;
      return catData;
    }

    catData = CatModel(
      id: cat.id,
      image: cat.image,
      fact: cat.fact,
      isFavorite: false,
    );

    return catData;
  }
}

class CatErrorState extends CatState {
  final String message;

  CatErrorState({this.message = 'Error!'});
}
