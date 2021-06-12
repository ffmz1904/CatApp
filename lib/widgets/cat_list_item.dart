import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/bloc/cat/cat_bloc.dart';
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
  CatListItem({Key? key, required this.cat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CatBloc catBloc = BlocProvider.of<CatBloc>(context);
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
                            cat: cat,
                          )));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //     fit: BoxFit.fill,
              //     image: NetworkImage(cat.image),
              //   ),
              // ),

              child: CachedNetworkImage(
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                imageUrl: cat.image,
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                final userId = (userBloc.state as UserAuthState).userData.id;
                catBloc
                    .add(CatAddToFavoriteEvent(catId: cat.id, userId: userId));
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
