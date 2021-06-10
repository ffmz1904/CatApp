import 'package:cat_app/models/cat_model.dart';
import 'package:cat_app/services/cat/cat_fact_provider.dart';
import 'package:cat_app/services/cat/cat_image_provider.dart';

class CatRepository {
  CatImageProvider _catImageProvider = CatImageProvider();
  CatFactProvider _catFactProvider = CatFactProvider();

  Future getCats(int limit, int page) async {
    List catImages = await _catImageProvider.getCats(limit, page);
    List catFacts = await _catFactProvider.getFacts(limit);

    List<Cat> cats = [];

    for (int i = 0; i < catImages.length; i++) {
      cats.add(Cat(
        image: catImages[i],
        fact: catFacts[i],
      ));
    }

    return cats;
  }
}
