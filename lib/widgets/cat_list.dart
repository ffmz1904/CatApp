import 'package:cat_app/bloc/cat/cat_block.dart';
import 'package:cat_app/bloc/cat/cat_events.dart';
import 'package:cat_app/models/cat_model.dart';
import 'package:cat_app/widgets/cat_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CatList extends StatefulWidget {
  List<Cat> cats;
  int page;
  CatList({Key? key, required this.cats, required this.page}) : super(key: key);

  @override
  _CatListState createState() => _CatListState();
}

class _CatListState extends State<CatList> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //getMoreCats
        CatBloc catBloc = BlocProvider.of<CatBloc>(context);
        catBloc.add(CatLoadEvent(page: widget.page + 1, cats: widget.cats));
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: widget.cats.length + 1,
        itemBuilder: (context, i) {
          if (i == widget.cats.length) {
            return Center(child: CircularProgressIndicator());
          }

          return CatListItem(cat: widget.cats[i]);
        });
  }
}
