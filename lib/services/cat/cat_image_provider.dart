import 'package:cat_app/core/constants.dart';
import 'package:cat_app/core/services/api_service.dart';
import 'package:http/http.dart' as http;

class CatImageProvider {
  /// Get list of cats images
  /// https://api.thecatapi.com/v1/images/search?limit=5&page=2&order=rand
  Future<List> getCats(int limit, int page) async {
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

  /// Save cat to favorite
  /// https://api.thecatapi.com/v1/favourites
  /// required headers  x-api-key
  Future addToFavorite(Map<String, dynamic> body) async {
    final response = await ApiService.post(
        endpoint: 'https://api.thecatapi.com/v1/favourites',
        body: body,
        headers: {'x-api-key': CAT_API_KEY}).request();

    return response;
  }

  Future<List> getFavorite(String userId, int limit, int page) async {
    final response = await ApiService.get(
        endpoint:
            'https://api.thecatapi.com/v1/favourites?sub_id=$userId&page=$page&limit=$limit',
        headers: {'x-api-key': CAT_API_KEY}).request();

    final List catImages = response
        .map((cat) => {
              'id': cat['image_id'],
              'img': cat['image']['url'],
            })
        .toList();
    return catImages;
  }
}
