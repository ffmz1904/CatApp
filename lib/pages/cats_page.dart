import 'package:cat_app/bloc/cat/cat_block.dart';
import 'package:cat_app/bloc/cat/cat_events.dart';
import 'package:cat_app/bloc/cat/cat_state.dart';
import 'package:cat_app/bloc/favorite/favorite_bloc.dart';
import 'package:cat_app/widgets/cat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatsPage extends StatelessWidget {
  const CatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CatBloc>(
      create: (context) => CatBloc(),
      child: BlocBuilder<CatBloc, CatState>(
        builder: (context, state) {
          final CatBloc catBloc = BlocProvider.of<CatBloc>(context);

          if (state is CatEmptyState) {
            catBloc.add(CatLoadEvent());
            return Center(
              child: Text('No cats yet!'),
            );
          }

          if (state is CatLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CatLoadedState) {
            void loadMore(page) {
              CatBloc catBloc = BlocProvider.of<CatBloc>(context);
              catBloc.add(CatLoadEvent(page: page + 1));
            }

            return BlocProvider<FavoriteBloc>(
              create: (context) => FavoriteBloc(),
              child: Container(
                child: CatList(
                    cats: state.cats, page: state.page, loadMore: loadMore),
              ),
            );
          }

          if (state is CatErrorState) {
            return Center(
              child: Text('Error cat fetching!'),
            );
          }

          return SizedBox();
        },
      ),
    );
  }
}
