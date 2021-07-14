import 'package:cat_app/features/profile/cubit/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  Future<void> changeCacheProvider(type) async {
    emit(SettingsState(
      cacheProvider: type,
      apiProvider: state.apiProvider,
    ));
  }

  Future<void> changeApiProvider(type) async {
    emit(SettingsState(
      cacheProvider: state.cacheProvider,
      apiProvider: type,
    ));
  }

}