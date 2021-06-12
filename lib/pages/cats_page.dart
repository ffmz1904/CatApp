import 'package:cat_app/bloc/cat/cat_bloc.dart';
import 'package:cat_app/bloc/cat/cat_events.dart';
import 'package:cat_app/bloc/cat/cat_state.dart';
import 'package:cat_app/widgets/cat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatsPage extends StatelessWidget {
  const CatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CatBloc catBloc = BlocProvider.of<CatBloc>(context);

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
        return CatList(catList: catState.catList);
      }

      return SizedBox();
    });
  }
}
