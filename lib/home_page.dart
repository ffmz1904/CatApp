import 'package:cat_app/features/cats/pages/cats_page.dart';
import 'package:cat_app/features/cats/pages/favorites_page.dart';
import 'package:cat_app/features/profile/profile_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat App',
      home: DefaultTabController(
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
            ),
          ),
          body: TabBarView(
            children: [
              CatsPage(),
              FavoritesPage(),
              ProfilePage(),
            ],
          ),
        ),
      ),
    );
  }
}
