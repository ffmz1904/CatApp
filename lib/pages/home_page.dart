import 'package:cat_app/bloc/cat/cat_bloc.dart';
import 'package:cat_app/bloc/user/user_bloc.dart';
import 'package:cat_app/pages/cats_page.dart';
import 'package:cat_app/pages/favorites_page.dart';
import 'package:cat_app/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
              title: Text('Cat App'),
              centerTitle: true,
              bottom: TabBar(
                tabs: [
                  Tab(
                    text: 'Cats',
                  ),
                  Tab(
                    text: 'Favorite',
                  ),
                  Tab(
                    text: 'Profile',
                  )
                ],
              )),
          body: MultiBlocProvider(
            providers: [
              BlocProvider<UserBloc>(
                create: (context) => UserBloc(),
              ),
              BlocProvider<CatBloc>(
                create: (context) => CatBloc(),
              ),
            ],
            child: TabBarView(children: [
              Container(
                child: CatsPage(),
              ),
              Container(
                child: FavoritesPage(),
              ),
              Container(
                child: ProfilePage(),
              ),
            ]),
          ),
        ));
  }
}
