import 'package:cat_app/bloc/cat/cat_bloc.dart';
import 'package:cat_app/bloc/cat/cat_events.dart';
import 'package:cat_app/bloc/user/user_bloc.dart';
import 'package:cat_app/bloc/user/user_state.dart';
import 'package:cat_app/models/cat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CatDetailsPage extends StatelessWidget {
  final CatModel cat;
  CatDetailsPage({Key? key, required this.cat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    CatBloc catBloc = BlocProvider.of<CatBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cat App'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(cat.image),
                ),
              ),
            ),
            BlocBuilder<UserBloc, UserState>(builder: (context, userState) {
              return IconButton(
                  onPressed: () {
                    if (cat.isFavorite) {
                      catBloc.add(CatRemoveFromFavoritesEvent(
                          favoriteId: cat.favoriteId));
                    } else {
                      final userId = (userState as UserAuthState).userData.id;
                      catBloc.add(
                          CatAddToFavoriteEvent(catId: cat.id, userId: userId));
                    }
                  },
                  icon: FaIcon(
                    cat.isFavorite
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: Colors.red[900],
                    size: 30,
                  ));
            }),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(cat.fact),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
