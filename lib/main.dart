import 'package:cat_app/features/cache/cache_provider_types.dart';
import 'package:cat_app/features/cache/shared_preferences/cat_shared_preferences_provider.dart';
import 'package:cat_app/features/cache/sqlite/cat_sqlite_provider.dart';
import 'package:cat_app/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/authentication/cubit/auth_cubit.dart';
import 'features/authentication/cubit/auth_state.dart';
import 'features/authentication/pages/auth_page.dart';
import 'features/authentication/repositories/authentication_repository.dart';
import 'features/cats/cubit/cat_cubit.dart';
import 'features/cats/repositories/cat_from_api_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    BlocProvider(
      create: (context) => AuthCubit(AuthenticationRepository()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthorizedState) {
          return BlocProvider<CatCubit>(
            create: (_) {
              return CatCubit(
                dataRepository: CatFromApiRepository(
                  cacheProvider:
                      state.cacheProviderType == CACHE_SHARED_PREFERENCES
                          ? CatSharedPreferencesProvider()
                          : CatSqliteProvider(),
                ),
              )..loadCats(state.userData.id);
            },
            child: HomePage(),
          );
        }

        return AuthPage();
      },
    );
  }
}
