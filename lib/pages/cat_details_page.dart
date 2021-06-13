import 'package:cat_app/bloc/cat/cat_bloc.dart';
import 'package:cat_app/bloc/cat/cat_events.dart';
import 'package:cat_app/bloc/cat/cat_state.dart';
import 'package:cat_app/bloc/favorite_cat/favorite_cat_bloc.dart';
import 'package:cat_app/bloc/favorite_cat/favorite_cat_state.dart';
import 'package:cat_app/bloc/user/user_bloc.dart';
import 'package:cat_app/bloc/user/user_state.dart';
import 'package:cat_app/models/cat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CatDetailsPage extends StatelessWidget {
  final CatModel cat;
  final Bloc bloc;
  CatDetailsPage({Key? key, required this.bloc, required this.cat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat App'),
        centerTitle: true,
      ),
      body: (bloc is CatBloc)
          ? BlocBuilder<CatBloc, CatState>(builder: (context, catState) {
              CatModel catDetail = (catState as CatLoadedState)
                  .catList
                  .where((c) => c.id == cat.id)
                  .toList()
                  .first;

              return _body(context, bloc, catDetail);
            })
          : BlocBuilder<FavoriteCatBloc, CatState>(
              builder: (context, favoriteState) {
              CatModel catDetail = (favoriteState as FavoriteCatLoadedState)
                  .catList
                  .where((c) => c.id == cat.id)
                  .toList()
                  .first;

              return _body(context, bloc, catDetail);
            }),
    );
  }

  Widget _body(context, bloc, catDetail) {
    CatBloc catBloc = BlocProvider.of<CatBloc>(context);
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(catDetail.image),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                if (catDetail.isFavorite) {
                  bloc.add(CatRemoveFromFavoritesEvent(
                      favoriteId: catDetail.favoriteId));
                } else {
                  final userId = (userBloc.state as UserAuthState).userData.id;
                  bloc.add(CatAddToFavoriteEvent(
                      catId: catDetail.id, userId: userId));
                }
              },
              icon: FaIcon(
                catDetail.isFavorite
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
                color: Colors.red[900],
                size: 30,
              )),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Text(catDetail.fact),
            ),
          ),
        ],
      ),
    );
  }
}
