import 'package:cat_app/features/cache/cache_provider.dart';
import 'package:cat_app/features/cats/api/cat_api_abstract.dart';
import 'package:cat_app/features/cats/model/cat_model.dart';
import 'package:cat_app/features/cats/repositories/cat_repository.dart';

class CatFromApiRepository extends CatRepository {
  final CatApiAbstract api;
  final CacheProvider cacheProvider;

  CatFromApiRepository({required this.cacheProvider, required this.api});

  @override
  Future<List<CatModel>> getCats(final int limit, final int page) async {
    try {
    final images = await api.getCatImages(limit, page);
      final facts = await api.getCatFacts(limit);

      final cats = <CatModel>[];

      for (var i = 0; i < images.length; i++) {
        cats.add(CatModel(
          id: images[i]['id'],
          image: images[i]['img'],
          fact: facts[i],
        ));
      }

      return cats;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<Map<String, dynamic>> addToFavorite(final String catId, final String userId) =>
      api.addCatToFavorite(catId, userId);

  @override
  Future<Map<String, dynamic>> removeFromFavorite(final dynamic favoriteId) =>
      api.removeCatFromFavorite(favoriteId);

  @override
  Future<List<CatModel>> getUserFavorites(final String userId, final int limit,
      [int page = 0]) async {
    try {
      List favorites = await api.getFavorites(userId, limit, page);
      List facts = await api.getCatFacts(limit);
      var cats = <CatModel>[];

      for (var i = 0; i < favorites.length; i++) {
        cats.add(CatModel(
          id: favorites[i]['id'],
          image: favorites[i]['img'],
          fact: facts[i],
          isFavorite: true,
          favoriteId: favorites[i]['favoriteId'],
        ));
      }
      return cats;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> setCatsToCache(final List<CatModel> data) async {
    await cacheProvider.setLocalData(data);
  }

  @override
  Future<List<CatModel>?> getCatsFromCache() async {
    final cats = await cacheProvider.getLocalData();
    return cats;
  }

  @override
  Future<void> closeCacheConnection() async {
    await cacheProvider.closeConnection();
  }
}
