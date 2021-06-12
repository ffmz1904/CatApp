import 'package:cat_app/bloc/cat/cat_state.dart';
import 'package:cat_app/bloc/favorite_cat/favorite_cat_bloc.dart';
import 'package:cat_app/bloc/favorite_cat/favorite_cat_events.dart';
import 'package:cat_app/bloc/favorite_cat/favorite_cat_state.dart';
import 'package:cat_app/bloc/user/user_bloc.dart';
import 'package:cat_app/bloc/user/user_state.dart';
import 'package:cat_app/widgets/cat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FavoriteCatBloc favoriteBloc = BlocProvider.of<FavoriteCatBloc>(context);
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return BlocBuilder<FavoriteCatBloc, CatState>(
        builder: (context, favoriteState) {
      if (favoriteState is FavoriteCatEmptyState) {
        favoriteBloc.add(FavoriteCatLoadEvent(
            userId: (userBloc.state as UserAuthState).userData.id));
        return Center(
          child: Text('No favorite yet!'),
        );
      }

      if (favoriteState is FavoriteCatLoadingState) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (favoriteState is FavoriteCatLoadedState) {
        loadMoreCats() {
          favoriteBloc.add(FavoriteCatLoadEvent(
              userId: (userBloc.state as UserAuthState).userData.id,
              page: favoriteState.page + 1));
          // (page: (catBloc.state as CatLoadedState).page + 1));
        }

        return Container(
          child:
              CatList(catList: favoriteState.catList, loadMore: loadMoreCats),
        );
      }

      if (favoriteState is FavoriteCatErrorState) {
        return Center(
          child: Text('No internet connection!'),
        );
      }

      return SizedBox();
    });
  }
}
