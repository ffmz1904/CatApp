import 'dart:convert';

class CatModel {
  dynamic id;
  String image;
  String fact;
  bool isFavorite = false;

  CatModel({
    required this.id,
    required this.image,
    required this.fact,
    this.isFavorite = false,
  });

  factory CatModel.fromJson(Map<String, dynamic> jsonData) {
    print(jsonData);
    return CatModel(
      id: jsonData['id'],
      image: jsonData['image'],
      fact: jsonData['fact'],
      isFavorite: jsonData['isFavorite'],
    );
  }

  static Map<String, dynamic> toMap(CatModel cat) => {
        'id': cat.id,
        'image': cat.image,
        'fact': cat.fact,
        'isFavorite': cat.isFavorite,
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
