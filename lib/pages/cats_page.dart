import 'package:cat_app/bloc/cat/cat_bloc.dart';
import 'package:cat_app/bloc/cat/cat_events.dart';
import 'package:cat_app/bloc/cat/cat_state.dart';
import 'package:cat_app/widgets/cat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const CAT_LIMIT = 5;

class CatsPage extends StatelessWidget {
  const CatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CatBloc catBloc = BlocProvider.of<CatBloc>(context);

    loadMoreCats() {
      catBloc
          .add(CatLoadEvent(page: (catBloc.state as CatLoadedState).page + 1));
    }

    return BlocBuilder<CatBloc, CatState>(builder: (context, catState) {
      if (catState is CatEmptyState) {
        catBloc.add(CatLoadEvent());
        return Center(
          child: Text('No cats yet!'),
        );
      }

      if (catState is CatLoadingState) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (catState is CatLoadedState) {
        return CatList(
          bloc: catBloc,
          catList: catState.catList,
          loadMore: loadMoreCats,
          limit: CAT_LIMIT,
        );
      }

      return SizedBox();
    });
  }
}
