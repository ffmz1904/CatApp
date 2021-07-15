import 'package:cat_app/core/services/api_service.dart';
import 'package:cat_app/features/cats/api/cat_api_abstract.dart';

const CAT_API_KEY = '53f28e90-2da9-4935-a8ce-ce25707666ae';

class CatApi extends CatApiAbstract {
  final ApiService _apiService = ApiService();

  /// get random cat images with pagination (page and limit)
  @override
  Future<List<Map<String, dynamic>>> getCatImages(int limit, int page) async {
    final response = await _apiService.get(endpoint: 'https://api.thecatapi.com/v1/images/search?limit=$limit&page=$page&order=rand');

    final catImages = (response as List).map((cat) => {
              'id': cat['id'],
              'img': cat['url'],
            })
        .toList();

    return catImages;
  }

  /// get random count (limit) of cat facts
  @override
  Future<List<String>> getCatFacts(int limit) async {
    final response = await _apiService.get(endpoint: 'https://catfact.ninja/facts?limit=$limit');

    final catFacts = ((response as Map<String, dynamic>)['data'] as List).map((fact) => fact['fact'].toString()).toList();
    return catFacts;
  }

  ///save cat image to favorite
  /// image_id: id from CatModel
  /// sub_id: user id
  @override
  Future<Map<String, dynamic>> addCatToFavorite(String catId, String userId) async {
    final response = await _apiService.post(
      endpoint: 'https://api.thecatapi.com/v1/favourites',
      body: {
        'image_id': catId,
        'sub_id': userId,
      },
      headers: {'x-api-key': CAT_API_KEY},
    );

    return response;
  }

  ///remove cat image from favorite
  /// favoriteId: id which we get when we add cat to favorites
  @override
  Future<Map<String, dynamic>> removeCatFromFavorite(dynamic favoriteId) async {
    final response = await _apiService.delete(
      endpoint: 'https://api.thecatapi.com/v1/favourites/$favoriteId',
      headers: {'x-api-key': CAT_API_KEY},
    );

    return response;
  }

  /// get favorites by user id with pagination (limit and page params)
  @override
  Future<List<Map<String, dynamic>>> getFavorites(String userId, int limit, int page) async {
    final response = await _apiService.get(
      endpoint:
          'https://api.thecatapi.com/v1/favourites?sub_id=$userId&limit=$limit&page=$page',
      headers: {'x-api-key': CAT_API_KEY},
    );

    final favoritesData = (response as List).map((favorite) => {
              'id': favorite['image']['id'],
              'img': favorite['image']['url'],
              'favoriteId': favorite['id'],
            })
        .toList();

    return favoritesData;
  }
}