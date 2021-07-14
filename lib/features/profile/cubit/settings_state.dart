import 'package:cat_app/features/cache/cache_provider_types.dart';
import 'package:cat_app/features/cats/api/cat_api_types.dart';

class SettingsState {
  String cacheProvider;
  String apiProvider;

  SettingsState({
    this.cacheProvider = CACHE_SHARED_PREFERENCES,
    this.apiProvider = CAT_API_CATS_API,
  });
}