import 'package:cat_app/features/cats/model/cat_model.dart';

enum CatTypes { cats, favorite }

abstract class CatRepository {
  Future<List<CatModel>> getCats(int limit, int page);

  Future<bool> setCatLocal(
      {required List<CatModel> catList, required CatTypes type});

  Future<List<CatModel>?> getCatLocal({required CatTypes type});

  Future addToFavorite(String catId, String userId);

  Future removeFromFavorite(dynamic favoriteId);

  Future<List<CatModel>> getUserFavorites(String userId, int limit, int page);
}
