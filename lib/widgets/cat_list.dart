import 'package:cat_app/models/cat_model.dart';
import 'package:cat_app/widgets/cat_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatList extends StatefulWidget {
  final List<CatModel> catList;
  final Function loadMore;
  final Bloc bloc;
  final int limit;

  CatList({
    Key? key,
    required this.bloc,
    required this.catList,
    required this.loadMore,
    required this.limit,
  }) : super(key: key);

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
        widget.loadMore();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int catLength = widget.catList.length;

    return Container(
      child: ListView.builder(
          controller: _scrollController,
          itemCount: catLength == widget.limit ? catLength + 1 : catLength,
          itemBuilder: (context, i) {
            if (i == catLength && catLength >= widget.limit) {
              return Center(child: CircularProgressIndicator());
            }

            return CatListItem(bloc: widget.bloc, cat: widget.catList[i]);
          }),
    );
  }
}
