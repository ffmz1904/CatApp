import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/bloc/cat/cat_events.dart';
import 'package:cat_app/bloc/user/user_bloc.dart';
import 'package:cat_app/bloc/user/user_state.dart';
import 'package:cat_app/models/cat_model.dart';
import 'package:cat_app/pages/cat_details_page.dart';
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
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

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
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                if (cat.isFavorite) {
                  bloc.add(
                      CatRemoveFromFavoritesEvent(favoriteId: cat.favoriteId));
                } else {
                  final userId = (userBloc.state as UserAuthState).userData.id;
                  bloc.add(
                      CatAddToFavoriteEvent(catId: cat.id, userId: userId));
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
