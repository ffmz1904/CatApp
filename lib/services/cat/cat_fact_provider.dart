import 'package:cat_app/core/services/api_service.dart';

class CatFactProvider {
  /// Get list of cat facts
  ///  from 'https://catfact.ninja/facts?limit=5'
  Future<List> getFacts() async {
    final response =
        await ApiService.get(endpoint: 'https://catfact.ninja/facts?limit=5')
            .request();

    List catFacts = response['data'].map((cat) => cat['fact']).toList();
    return catFacts;
  }
}
