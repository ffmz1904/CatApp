import 'package:cat_app/bloc/user/user_bloc.dart';
import 'package:cat_app/bloc/user/user_state.dart';
import 'package:cat_app/pages/auth_page.dart';
import 'package:cat_app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cat App",
      // initialRoute: "/",
      // routes: {
      //   "/": (context) => HomePage(),
      //   "/auth": (context) => AuthPage(),
      // },
      home: BlocProvider<UserBloc>(
        create: (context) => UserBloc(),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserNotAuthState) {
              return AuthPage();
            }

            return HomePage();
          },
        ),
      ),
    );
  }
}
