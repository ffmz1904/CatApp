import 'package:cat_app/features/cats/api/cat_api_abstract.dart';
import 'package:cloud_functions/cloud_functions.dart';

class CatFirestoreApi extends CatApiAbstract {
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  /// get cat images with pagination (page and limit)
  @override
  Future<List<Map<String, dynamic>>> getCatImages(final int limit, final int page) async {
    var callable = functions.httpsCallable('getImages');
    final results = await callable.call({
      'page': page,
      'limit': limit,
    });

    final catImages = (results.data as List).map((cat) => {
      'id': cat['id'],
      'img': cat['image'],
    }).toList();

    return catImages;
  }

  /// get random count (limit) of cat facts
  @override
  Future<List<String>> getCatFacts(final int limit) async {
    var callable = functions.httpsCallable('getFacts');
    final results = await callable.call({ 'limit': limit });
    final catFacts = (results.data as List).map((fact) => fact['text'].toString()).toList();
    return catFacts;
  }

  ///save cat image to favorite
  /// catId: id from CatModel
  @override
  Future<Map<String, dynamic>> addCatToFavorite(final String catId, final String userId) async {
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
  Future<Map<String, dynamic>> removeCatFromFavorite(final dynamic favoriteId) async {
    var callable = functions.httpsCallable('removeFavorite');
    final results = await callable.call({ 'favoriteId': favoriteId });

    return results.data;
  }

  /// get favorites by user id with pagination (limit and page params)
  @override
  Future<List<Map<String, dynamic>>> getFavorites(final String userId, final int limit, final int page) async {
    var callable = functions.httpsCallable('getUserFavorites');
    final results = await callable.call({
      'userId': userId,
      'limit': limit,
      'page': page,
    });

    final favoritesData = (results.data as List).map((favorite) => {
      'id': favorite['catId'],
      'img': favorite['image'],
      'favoriteId': favorite['favoriteId'],
    }).toList();

    return favoritesData;
  }
}
