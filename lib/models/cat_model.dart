import 'dart:convert';

class CatModel {
  dynamic id;
  String image;
  String fact;
  bool isFavorite = false;
  dynamic favoriteId;

  CatModel({
    required this.id,
    required this.image,
    required this.fact,
    this.isFavorite = false,
    this.favoriteId,
  });

  factory CatModel.fromJson(Map<String, dynamic> jsonData) {
    return CatModel(
        id: jsonData['id'],
        image: jsonData['image'],
        fact: jsonData['fact'],
        isFavorite: jsonData['isFavorite'],
        favoriteId: jsonData['favoriteId']);
  }

  static Map<String, dynamic> toMap(CatModel cat) => {
        'id': cat.id,
        'image': cat.image,
        'fact': cat.fact,
        'isFavorite': cat.isFavorite,
        'favoriteId': cat.favoriteId,
      };

  static String encode(List<CatModel> catList) => json.encode(
        catList
            .map<Map<String, dynamic>>((cat) => CatModel.toMap(cat))
            .toList(),
      );

  static List<CatModel> decode(String catListString) =>
      (json.decode(catListString) as List<dynamic>)
          .map<CatModel>((item) => CatModel.fromJson(item))
          .toList();
}
