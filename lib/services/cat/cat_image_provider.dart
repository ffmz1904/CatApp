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

    final List catImages = response.map((cat) => cat['url']).toList();

    return catImages;
  }
}
