import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/bloc/cat/cat_bloc.dart';
import 'package:cat_app/bloc/cat/cat_events.dart';
import 'package:cat_app/bloc/favorite_cat/favorite_cat_bloc.dart';
import 'package:cat_app/features/cats/model/cat_model.dart';
import 'package:cat_app/features/cats/pages/cat_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CatListItem extends StatelessWidget {
  final CatModel cat;
  final Bloc bloc;
  CatListItem({Key? key, required this.bloc, required this.cat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CatDetailsPage(
                            bloc: bloc,
                            cat: cat,
                          )));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                imageUrl: cat.image,
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                if (cat.isFavorite) {
                  final favoriteId = cat.favoriteId;
                  bloc.add(CatRemoveFromFavoritesEvent(favoriteId: favoriteId));

                  if (bloc is FavoriteCatBloc) {
                    CatBloc catBloc = BlocProvider.of<CatBloc>(context);
                    catBloc.add(CatRemoveFromFavoritesEvent(
                        favoriteId: favoriteId, favoriteBlocEvent: true));
                  }
                } else {
                  // final userId = (userBloc.state as UserAuthState).userData.id;
                  // bloc.add(
                  //     CatAddToFavoriteEvent(catId: cat.id, userId: userId));
                }
              },
              icon: FaIcon(
                cat.isFavorite
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
                color: Colors.red[900],
                size: 30,
              )),
        ],
      ),
    );
  }
}
