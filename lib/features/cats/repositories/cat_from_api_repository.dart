import 'package:cat_app/features/cats/api/cat_api.dart';
import 'package:cat_app/features/cats/model/cat_model.dart';
import 'package:cat_app/features/cats/repositories/cat_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatFromApiRepository extends CatRepository {
  CatApi api = CatApi();
  final String localCatKey = 'CAT_LIST_LOCAL';
  final String localFavoriteCatKey = 'FAVORITE_CAT_LIST_LOCAL';

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

  // @override
  // Future<bool> setCatLocal(
  //     {required List<CatModel> catList, required CatTypes type}) async {
  //   var key = (type == CatTypes.favorite) ? localFavoriteCatKey : localCatKey;
  //   final local = await SharedPreferences.getInstance();
  //   final catListString = CatModel.encode(catList);

  //   await local.setString(key, catListString);
  //   print('set cat in cache');
  //   return true;
  // }

  // @override
  // Future<List<CatModel>?> getCatLocal({required CatTypes type}) async {
  //   var key = (type == CatTypes.favorite) ? localFavoriteCatKey : localCatKey;
  //   final local = await SharedPreferences.getInstance();
  //   final catListString = local.getString(key);

  //   if (catListString == null) {
  //     return null;
  //   }

  //   final catList = CatModel.decode(catListString);
  //   return catList;
  // }

  @override
  Future addToFavorite(String catId, String userId) =>
      api.addCatToFavorite(catId, userId);

  @override
  Future removeFromFavorite(dynamic favoriteId) =>
      api.removeCatFromFavorite(favoriteId);

  @override
  Future<List<CatModel>> getUserFavorites(
      String userId, int limit, int page) async {
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
}
