import 'package:cat_app/models/cat_model.dart';
import 'package:cat_app/widgets/cat_list_item.dart';
import 'package:flutter/material.dart';

class CatList extends StatelessWidget {
  final List<CatModel> catList;

  CatList({Key? key, required this.catList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: catList.length,
          itemBuilder: (context, i) {
            return CatListItem(cat: catList[i]);
          }),
    );
  }
}

  // ScrollController _scrollController = ScrollController();

  // @override
  // void initState() {
  //   super.initState();

  //   _scrollController.addListener(() {
  //     if (_scrollController.position.pixels ==
  //         _scrollController.position.maxScrollExtent) {
  //       //getMoreCats
  //       widget.loadMore(widget.page);
  //       setState(() {});
  //     }
  //   });
  // }

  // return ListView.builder(
  //       controller: _scrollController,
  //       itemCount: widget.cats.length + 1,
  //       itemBuilder: (context, i) {
  //         if (i == widget.cats.length) {
  //           return Center(child: CircularProgressIndicator());
  //         }

  //         return CatListItem(cat: widget.cats[i]);
  //       });
