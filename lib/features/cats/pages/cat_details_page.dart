import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/features/cats/cubit/cat/cat_cubit.dart';
import 'package:cat_app/features/cats/cubit/cat/cat_state.dart';
import 'package:cat_app/features/cats/model/cat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CatDetailsPage extends StatelessWidget {
  final CatModel cat;
  CatDetailsPage({Key? key, required this.cat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat App'),
        centerTitle: true,
      ),
      body: BlocBuilder<CatCubit, CatState>(
        builder: (context, catState) {
          final catDetail = cat;

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
                  onPressed: () {},
                  icon: FaIcon(
                    catDetail.isFavorite
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: Colors.red[900],
                    size: 30,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    child: Text(catDetail.fact),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
