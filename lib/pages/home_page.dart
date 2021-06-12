import 'package:cat_app/bloc/cat/cat_bloc.dart';
import 'package:cat_app/bloc/favorite_cat/favorite_cat_bloc.dart';
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
              BlocProvider<CatBloc>(
                create: (context) => CatBloc(),
              ),
              BlocProvider<FavoriteCatBloc>(
                  create: (context) => FavoriteCatBloc()),
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
