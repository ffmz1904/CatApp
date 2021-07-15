import 'package:cat_app/features/cache/cache_provider_types.dart';
import 'package:cat_app/features/cats/api/cat_api_types.dart';

class SettingsState {
  final String cacheProvider;
  final String apiProvider;

  SettingsState({
    this.cacheProvider = CACHE_SHARED_PREFERENCES,
    this.apiProvider = CAT_API_CATS_API,
  });

  SettingsState copyWith({
    final String? cacheProvider,
    final String? apiProvider,
  }) {
    return SettingsState(
      cacheProvider: cacheProvider ?? this.cacheProvider,
      apiProvider: apiProvider ?? this.apiProvider,
    );
  }
}
