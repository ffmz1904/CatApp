import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/features/authentication/cubit/auth_cubit.dart';
import 'package:cat_app/features/authentication/cubit/auth_state.dart';
import 'package:cat_app/features/cats/cubit/cat/cat_cubit.dart';
import 'package:cat_app/features/cats/cubit/favorite/favorite_cubit.dart';
import 'package:cat_app/features/cats/model/cat_model.dart';
import 'package:cat_app/features/cats/pages/cat_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CatListItem extends StatelessWidget {
  final CatModel cat;
  final Cubit cubit;
  CatListItem({Key? key, required this.cubit, required this.cat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final catCubit = context.read<CatCubit>();
    final favoriteCubit = context.read<FavoriteCatCubit>();

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
                            cubit: cubit,
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

                  if (cubit is CatCubit) {
                    catCubit.removeFromFavorites(favoriteId);
                  } else {
                    favoriteCubit.removeFavorite(favoriteId);
                    catCubit.removeFromFavorites(favoriteId, true);
                  }
                } else {
                  final userId =
                      (authCubit.state as AuthAuthorizedState).userData.id;
                  if (cubit is CatCubit) {
                    catCubit.addFavorite(cat.id, userId);
                  } else {
                    favoriteCubit.addToFavorite(cat.id, userId);
                  }
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
