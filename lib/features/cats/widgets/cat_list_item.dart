import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_app/features/cats/model/cat_model.dart';
import 'package:cat_app/features/cats/pages/cat_details_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CatListItem extends StatelessWidget {
  final CatModel cat;
  CatListItem({Key? key, required this.cat}) : super(key: key);

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
                } else {}
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
