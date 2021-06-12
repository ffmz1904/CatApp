import 'package:cat_app/api/api_service.dart';
import 'package:http/http.dart';

class CatApi {
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

  Future getCatFacts(int limit) async {
    final response = await ApiService.get(
            endpoint: 'https://catfact.ninja/facts?limit=$limit')
        .request();

    final List catFacts = response['data'].map((fact) => fact['fact']).toList();
    return catFacts;
  }
}
