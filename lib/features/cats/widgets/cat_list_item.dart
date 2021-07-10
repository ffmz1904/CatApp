import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/features/authentication/cubit/auth_cubit.dart';
import 'package:cat_app/features/cats/cubit/cat_cubit.dart';
import 'package:cat_app/features/cats/model/cat_model.dart';
import 'package:cat_app/features/cats/pages/cat_details_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatListItem extends StatelessWidget {
  final CatModel cat;
  final CatTypes pageType;
  CatListItem({
    Key? key,
    required this.cat,
    required this.pageType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  context.read<CatCubit>().removeFromFavorite(cat.favoriteId);
                } else {
                  context
                      .read<CatCubit>()
                      .addFavorite(cat.id, context.read<AuthCubit>().userId);
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
