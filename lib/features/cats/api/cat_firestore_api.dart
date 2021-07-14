import 'package:cat_app/features/cats/api/cat_api_abstract.dart';
import 'package:cloud_functions/cloud_functions.dart';

class CatFirestoreApi extends CatApiAbstract {
  FirebaseFunctions functions = FirebaseFunctions.instance;
  /// get cat images with pagination (page and limit)
  @override
  Future getCatImages(int limit, int page) async {
    var callable = functions.httpsCallable('getImages');
    final results = await callable.call({
      'page': page,
      'limit': limit,
    });

    final List catImages = results.data.map((cat) => {
      'id': cat['id'],
      'img': cat['image'],
    }).toList();

    return catImages;
  }

  /// get random count (limit) of cat facts
  @override
  Future getCatFacts(int limit) async {
    var callable = functions.httpsCallable('getFacts');
    final results = await callable.call({ 'limit': limit });
    final List catFacts = results.data.map((fact) => fact['text']).toList();
    return catFacts;
  }

  ///save cat image to favorite
  /// catId: id from CatModel
  @override
  Future addCatToFavorite(String catId, String userId) async {
    var callable = functions.httpsCallable('addToFavorites');
    final results = await callable.call({
      'catId': catId,
      'userId': userId,
    });

    return results.data;
  }

  ///remove cat image from favorite
  /// favoriteId: id which we get when we add cat to favorites
  @override
  Future removeCatFromFavorite(dynamic favoriteId) async {
    var callable = functions.httpsCallable('removeFavorite');
    final results = await callable.call({ 'favoriteId': favoriteId });

    return results.data;
  }

  /// get favorites by user id with pagination (limit and page params)
  @override
  Future getFavorites(String userId, int limit, int page) async {
    var callable = functions.httpsCallable('getUserFavorites');
    final results = await callable.call({
      'userId': userId,
      'limit': limit,
      'page': page,
    });

    List favoritesData = results.data.map((favorite) => {
      'id': favorite['catId'],
      'img': favorite['image'],
      'favoriteId': favorite['favoriteId'],
    }).toList();

    return favoritesData;
  }
}
