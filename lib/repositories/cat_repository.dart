import 'package:cat_app/api/cat_api.dart';
import 'package:cat_app/models/cat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatRepository {
  CatApi api = CatApi();
  final String localKey = 'CAT_LIST_LOCAL';

  Future getCats(int limit, int page) async {
    try {
      List images = await api.getCatImages(limit, page);

      List<CatModel> cats = [];

      for (int i = 0; i < images.length; i++) {
        cats.add(CatModel(
          id: images[i]['id'],
          image: images[i]['img'],
          fact: 'hardcode',
        ));
      }

      return cats;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future setCatLocal({required List<CatModel> catList}) async {
    SharedPreferences local = await SharedPreferences.getInstance();
    String catListString = CatModel.encode(catList);
    await local.setString(localKey, catListString);
    print('set cat in cache');
    return true;
  }

  Future getCatLocal() async {
    SharedPreferences local = await SharedPreferences.getInstance();
    String? catListString = local.getString(localKey);

    if (catListString == null) {
      return null;
    }

    List<CatModel> catList = CatModel.decode(catListString);
    return catList;
  }
}
