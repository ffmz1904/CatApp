import 'package:cat_app/bloc/cat/cat_bloc.dart';
import 'package:cat_app/bloc/favorite_cat/favorite_cat_bloc.dart';
import 'package:cat_app/bloc/user/user_bloc.dart';
import 'package:cat_app/bloc/user/user_events.dart';
import 'package:cat_app/pages/auth_page.dart';
import 'package:cat_app/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user/user_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<UserBloc>(create: (_) => UserBloc()),
      BlocProvider<CatBloc>(create: (_) => CatBloc()),
      BlocProvider<FavoriteCatBloc>(create: (_) => FavoriteCatBloc()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cat App",
      home: BlocProvider<UserBloc>(
        create: (context) => UserBloc(),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            final UserBloc userBloc = BlocProvider.of<UserBloc>(context);

            if (userState is UserEmptyState) {
              userBloc.add(UserGetCacheDataEvent());
            }

            if (userState is UserAuthState) {
              return HomePage();
            }

            return AuthPage();
          },
        ),
      ),
    );
  }
}
