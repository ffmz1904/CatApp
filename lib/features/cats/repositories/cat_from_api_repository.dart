import 'package:cat_app/features/cache/cache_provider.dart';
import 'package:cat_app/features/cats/api/cat_api.dart';
import 'package:cat_app/features/cats/model/cat_model.dart';
import 'package:cat_app/features/cats/repositories/cat_repository.dart';

class CatFromApiRepository extends CatRepository {
  CatApi api = CatApi();
  CacheProvider cacheProvider;

  CatFromApiRepository({required this.cacheProvider});

  @override
  Future<List<CatModel>> getCats(int limit, int page) async {
    try {
      List images = await api.getCatImages(limit, page);
      List facts = await api.getCatFacts(limit);

      var cats = <CatModel>[];

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
  Future addToFavorite(String catId, String userId) =>
      api.addCatToFavorite(catId, userId);

  @override
  Future removeFromFavorite(dynamic favoriteId) =>
      api.removeCatFromFavorite(favoriteId);

  @override
  Future<List<CatModel>> getUserFavorites(String userId, int limit,
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
  Future<void> setCatsToCache(data) async {
    await cacheProvider.setLocalData(data);
  }

  @override
  Future<List<CatModel>?> getCatsFromCache() async {
    final cats = await cacheProvider.getLocalData();
    return cats;
  }
}
