import 'package:cat_app/api/cat_api.dart';
import 'package:cat_app/models/cat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CatTypes { cats, favorite }

class CatRepository {
  CatApi api = CatApi();
  final String localCatKey = 'CAT_LIST_LOCAL';
  final String localFavoriteCatKey = 'FAVORITE_CAT_LIST_LOCAL';

  Future getCats(int limit, int page) async {
    try {
      List images = await api.getCatImages(limit, page);
      List facts = await api.getCatFacts(limit);

      List<CatModel> cats = [];

      for (int i = 0; i < images.length; i++) {
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

  Future setCatLocal(
      {required List<CatModel> catList, required CatTypes type}) async {
    String key =
        (type == CatTypes.favorite) ? localFavoriteCatKey : localCatKey;
    SharedPreferences local = await SharedPreferences.getInstance();
    String catListString = CatModel.encode(catList);

    await local.setString(key, catListString);
    print('set cat in cache');
    return true;
  }

  Future getCatLocal({required CatTypes type}) async {
    String key =
        (type == CatTypes.favorite) ? localFavoriteCatKey : localCatKey;
    SharedPreferences local = await SharedPreferences.getInstance();
    String? catListString = local.getString(key);

    if (catListString == null) {
      return null;
    }

    List<CatModel> catList = CatModel.decode(catListString);
    return catList;
  }

  Future addToFavorite(String catId, String userId) =>
      api.addCatToFavorite(catId, userId);

  Future removeFromFavorite(dynamic favoriteId) =>
      api.removeCatFromFavorite(favoriteId);

  Future getUserFavorites(String userId, int limit, int page) async {
    try {
      List favorites = await api.getFavorites(userId, limit, page);
      List facts = await api.getCatFacts(limit);

      List<CatModel> cats = [];

      for (int i = 0; i < favorites.length; i++) {
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
