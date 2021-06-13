import 'package:cat_app/bloc/cat/cat_state.dart';
import 'package:cat_app/bloc/favorite_cat/favorite_cat_bloc.dart';
import 'package:cat_app/bloc/favorite_cat/favorite_cat_events.dart';
import 'package:cat_app/bloc/favorite_cat/favorite_cat_state.dart';
import 'package:cat_app/bloc/user/user_bloc.dart';
import 'package:cat_app/bloc/user/user_state.dart';
import 'package:cat_app/widgets/cat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const CAT_LIMIT = 5;

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FavoriteCatBloc favoriteBloc = BlocProvider.of<FavoriteCatBloc>(context);
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    favoriteBloc.add(FavoriteCatLoadEvent(
        userId: (userBloc.state as UserAuthState).userData.id));

    return BlocBuilder<FavoriteCatBloc, CatState>(
        builder: (context, favoriteState) {
      if (favoriteState is FavoriteCatEmptyState) {
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
        }

        return Container(
          child: CatList(
            bloc: favoriteBloc,
            catList: favoriteState.catList
                .where((cat) => cat.favoriteId != null)
                .toList(),
            loadMore: loadMoreCats,
            limit: CAT_LIMIT,
          ),
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
