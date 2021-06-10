import 'package:cat_app/bloc/favorite/favorite_bloc.dart';
import 'package:cat_app/bloc/favorite/favorite_events.dart';
import 'package:cat_app/bloc/user/user_bloc.dart';
import 'package:cat_app/bloc/user/user_state.dart';
import 'package:cat_app/models/cat_model.dart';
import 'package:cat_app/pages/cat_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CatListItem extends StatelessWidget {
  Cat cat;
  CatListItem({Key? key, required this.cat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FavoriteBloc favoriteBloc = BlocProvider.of<FavoriteBloc>(context);

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
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(cat.image),
                ),
              ),
            ),
          ),
          BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            return IconButton(
                onPressed: () {
                  print('1');
                  if (state is UserAuthState) {
                    print('2');
                    favoriteBloc.add(FavoriteAddEvent(
                        imgId: cat.id, userId: state.userData.id));
                  }
                },
                icon: FaIcon(
                  FontAwesomeIcons.heart,
                  color: Colors.red[900],
                  size: 30,
                ));
          }),
        ],
      ),
    );
  }
}
