import 'package:cat_app/authentication/cubit/auth_cubit.dart';
import 'package:cat_app/authentication/cubit/auth_state.dart';
import 'package:cat_app/authentication/repositories/authentication_repository.dart';
import 'package:cat_app/authentication/pages/auth_page.dart';
import 'package:cat_app/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cat App",
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => AuthCubit(AuthenticationRepository()),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState);
            if (authState is AuthUnauthorizedState) {
              return AuthPage();
            }

            if (authState is AuthAuthorizedState) {
              return HomePage();
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
