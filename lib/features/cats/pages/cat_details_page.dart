import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/features/authentication/cubit/auth_cubit.dart';
import 'package:cat_app/features/authentication/cubit/auth_state.dart';
import 'package:cat_app/features/cats/cubit/cat/cat_cubit.dart';
import 'package:cat_app/features/cats/cubit/cat/cat_state.dart';
import 'package:cat_app/features/cats/cubit/favorite/favorite_cubit.dart';
import 'package:cat_app/features/cats/cubit/favorite/favorite_state.dart';
import 'package:cat_app/features/cats/model/cat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CatDetailsPage extends StatelessWidget {
  final CatModel cat;
  final Cubit cubit;
  CatDetailsPage({Key? key, required this.cubit, required this.cat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CatCubit catCubit = context.read<CatCubit>();
    FavoriteCatCubit favoriteCubit = context.read<FavoriteCatCubit>();
    AuthCubit authCubit = context.read<AuthCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cat App'),
        centerTitle: true,
      ),
      body: (cubit is CatCubit)
          ? BlocBuilder<CatCubit, CatState>(builder: (context, catState) {
              CatModel catDetail = (catState as CatLoadedState)
                  .catList
                  .where((c) => c.id == cat.id)
                  .toList()
                  .first;

              return _body(context, cubit, catDetail, catCubit, favoriteCubit,
                  authCubit);
            })
          : BlocBuilder<FavoriteCatCubit, CatState>(
              builder: (context, favoriteState) {
              CatModel catDetail = (favoriteState as FavoriteCatLoadedState)
                  .catList
                  .where((c) => c.id == cat.id)
                  .toList()
                  .first;

              return _body(context, cubit, catDetail, catCubit, favoriteCubit,
                  authCubit);
            }),
    );
  }

  Widget _body(context, cubit, catDetail, catCubit, favoriteCubit, authCubit) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
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
          IconButton(
              onPressed: () {
                if (catDetail.isFavorite) {
                  if (cubit is CatCubit) {
                    catCubit.removeFromFavorites(catDetail.favoriteId);
                  } else {
                    favoriteCubit.removeFavorite(catDetail.favoriteId);
                  }
                } else {
                  final userId =
                      (authCubit.state as AuthAuthorizedState).userData.id;

                  if (cubit is CatCubit) {
                    catCubit.addFavorite(catDetail.id, userId);
                  } else {
                    favoriteCubit.addToFavorite(catDetail.id, userId);
                  }
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
