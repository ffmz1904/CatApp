import 'package:cat_app/features/cats/model/cat_model.dart';

abstract class CatRepository {
  Future<List<CatModel>> getCats(final int limit, final int page);

  Future<Map<String, dynamic>> addToFavorite(final String catId, final String userId);

  Future<Map<String, dynamic>> removeFromFavorite(final dynamic favoriteId);

  Future<List<CatModel>> getUserFavorites(final String userId, final int limit,
      [final int page = 0]);

  Future<void> setCatsToCache(final List<CatModel> data);

  Future<List<CatModel>?> getCatsFromCache();

  Future<void> closeCacheConnection();
}
