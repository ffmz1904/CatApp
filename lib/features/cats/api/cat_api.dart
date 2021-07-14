import 'package:cat_app/core/services/api_service.dart';
import 'package:cat_app/features/cats/api/cat_api_abstract.dart';

const CAT_API_KEY = '53f28e90-2da9-4935-a8ce-ce25707666ae';

class CatApi extends CatApiAbstract {
  /// get random cat images with pagination (page and limit)
  @override
  Future getCatImages(int limit, int page) async {
    final response = await ApiService.get(
            endpoint:
                'https://api.thecatapi.com/v1/images/search?limit=$limit&page=$page&order=rand')
        .request();

    final List catImages = response
        .map((cat) => {
              'id': cat['id'],
              'img': cat['url'],
            })
        .toList();

    return catImages;
  }

  /// get random count (limit) of cat facts
  @override
  Future getCatFacts(int limit) async {
    final response = await ApiService.get(
            endpoint: 'https://catfact.ninja/facts?limit=$limit')
        .request();

    final List catFacts = response['data'].map((fact) => fact['fact']).toList();
    return catFacts;
  }

  ///save cat image to favorite
  /// image_id: id from CatModel
  /// sub_id: user id
  @override
  Future addCatToFavorite(String catId, String userId) async {
    final response = await ApiService.post(
      endpoint: 'https://api.thecatapi.com/v1/favourites',
      body: {
        'image_id': catId,
        'sub_id': userId,
      },
      headers: {'x-api-key': CAT_API_KEY},
    ).request();

    return response;
  }

  ///remove cat image from favorite
  /// favoriteId: id which we get when we add cat to favorites
  @override
  Future removeCatFromFavorite(dynamic favoriteId) async {
    final response = await ApiService.delete(
      endpoint: 'https://api.thecatapi.com/v1/favourites/$favoriteId',
      headers: {'x-api-key': CAT_API_KEY},
    ).request();

    return response;
  }

  /// get favorites by user id with pagination (limit and page params)
  @override
  Future getFavorites(String userId, int limit, int page) async {
    final response = await ApiService.get(
      endpoint:
          'https://api.thecatapi.com/v1/favourites?sub_id=$userId&limit=$limit&page=$page',
      headers: {'x-api-key': CAT_API_KEY},
    ).request();

    List favoritesData = response
        .map((favorite) => {
              'id': favorite['image']['id'],
              'img': favorite['image']['url'],
              'favoriteId': favorite['id'],
            })
        .toList();

    return favoritesData;
  }
}
