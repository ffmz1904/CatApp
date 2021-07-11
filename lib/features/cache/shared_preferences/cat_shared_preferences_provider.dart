import 'package:cat_app/features/cache/cache_provider.dart';
import 'package:cat_app/features/cats/model/cat_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const LOCAL_CAT_KEY = 'CAT_LOCAL';

class CatSharedPreferencesProvider extends CacheProvider {
  @override
  Future getLocalData() async {
    final instance = await SharedPreferences.getInstance();
    final data = instance.get(LOCAL_CAT_KEY);

    if (data == null) {
      return null;
    }

    print('get from shared pref cache');
    return CatModel.decode(data.toString());
  }

  @override
  Future<void> setLocalData(data) async {
    final instance = await SharedPreferences.getInstance();
    final dataToString = CatModel.encode(data);
    await instance.setString(LOCAL_CAT_KEY, dataToString);
    print('set to shared preferences cache');
  }
}
