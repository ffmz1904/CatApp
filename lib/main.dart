import 'package:cat_app/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/authentication/cubit/auth_cubit.dart';
import 'features/authentication/cubit/auth_state.dart';
import 'features/authentication/pages/auth_page.dart';
import 'features/authentication/repositories/authentication_repository.dart';
import 'features/cats/cubit/cat/cat_cubit.dart';
import 'features/cats/cubit/favorite/favorite_cubit.dart';
import 'features/cats/repositories/cat_from_api_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    BlocProvider(
        create: (context) => AuthCubit(AuthenticationRepository()),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cat App",
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState is AuthEmptyState) {
            context.read<AuthCubit>().getCachedData();
          }

          if (authState is AuthUnauthorizedState) {
            return AuthPage();
          }

          if (authState is AuthAuthorizedState) {
            return MultiBlocProvider(providers: [
              BlocProvider(
                  create: (context) => CatCubit(CatFromApiRepository())),
              BlocProvider(
                  create: (context) =>
                      FavoriteCatCubit(CatFromApiRepository())),
            ], child: HomePage());
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
