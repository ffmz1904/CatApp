import 'package:cat_app/features/cats/model/cat_model.dart';

abstract class CatRepository {
  Future<List<CatModel>> getCats(int limit, int page);

  Future<Map<String, dynamic>> addToFavorite(String catId, String userId);

  Future<Map<String, dynamic>> removeFromFavorite(dynamic favoriteId);

  Future<List<CatModel>> getUserFavorites(String userId, int limit,
      [int page = 0]);

  Future<void> setCatsToCache(List<CatModel> data);

  Future<List<CatModel>?> getCatsFromCache();

  Future<void> closeCacheConnection();
}
