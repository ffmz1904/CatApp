import 'package:cat_app/models/cat_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CatDetailsPage extends StatelessWidget {
  CatModel cat;
  CatDetailsPage({Key? key, required this.cat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat App'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(cat.image),
                ),
              ),
            ),
            IconButton(
                onPressed: null,
                icon: FaIcon(FontAwesomeIcons.heart,
                    color: Colors.red[900], size: 30)),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(cat.fact),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
