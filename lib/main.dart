import 'package:cat_app/features/cache/cache_provider_types.dart';
import 'package:cat_app/features/cache/shared_preferences/cat_shared_preferences_provider.dart';
import 'package:cat_app/features/cache/sqlite/cat_sqlite_provider.dart';
import 'package:cat_app/features/cats/api/cat_api_types.dart';
import 'package:cat_app/features/cats/api/cat_firestore_api.dart';
import 'package:cat_app/features/profile/cubit/settings_cubit.dart';
import 'package:cat_app/features/profile/cubit/settings_state.dart';
import 'package:cat_app/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/authentication/cubit/auth_cubit.dart';
import 'features/authentication/cubit/auth_state.dart';
import 'features/authentication/pages/auth_page.dart';
import 'features/authentication/repositories/authentication_repository.dart';
import 'features/cats/api/cat_api.dart';
import 'features/cats/cubit/cat_cubit.dart';
import 'features/cats/repositories/cat_from_api_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => AuthCubit(AuthenticationRepository()),
      ),
      BlocProvider(create: (context) => SettingsCubit()),
    ], child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthorizedState) {
          return BlocBuilder<SettingsCubit, SettingsState>(builder: (context, settingsState) {
            final catCubit = CatCubit(
              dataRepository: CatFromApiRepository(
                cacheProvider: settingsState.cacheProvider == CACHE_SHARED_PREFERENCES
                    ? CatSharedPreferencesProvider()
                    : CatSqliteProvider(),
                api: settingsState.apiProvider == CAT_API_CATS_API
                    ? CatApi()
                    : CatFirestoreApi(),
              ),
            )..loadCats(state.userData.id);

            return BlocProvider.value(
              value: catCubit,
              child: HomePage(),
            );
          });
        }

        return AuthPage();
      },
    );
  }
}
