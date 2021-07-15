import 'package:cat_app/features/cats/model/cat_model.dart';

abstract class ICache {
  // Set data to cache
  Future<void> setLocalData(List<CatModel> data);

  // Get data from cache
  Future<List<CatModel>?> getLocalData();

  Future<void> closeConnection();
}
