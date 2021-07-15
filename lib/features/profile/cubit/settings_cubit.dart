import 'package:cat_app/features/profile/cubit/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState());

  Future<void> changeCacheProvider(final String type) async {
    emit(state.copyWith(
      cacheProvider: type,
    ));
  }

  Future<void> changeApiProvider(final String type) async {
    emit(state.copyWith(
      apiProvider: type,
    ));
  }

}