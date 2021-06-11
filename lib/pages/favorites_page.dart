import 'package:cat_app/bloc/favorite/favorite_bloc.dart';
import 'package:cat_app/bloc/favorite/favorite_events.dart';
import 'package:cat_app/bloc/favorite/favorite_state.dart';
import 'package:cat_app/bloc/user/user_bloc.dart';
import 'package:cat_app/bloc/user/user_state.dart';
import 'package:cat_app/widgets/cat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoriteBloc>(
      create: (context) => FavoriteBloc(),
      child: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          return BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
            final FavoriteBloc favoriteBloc =
                BlocProvider.of<FavoriteBloc>(context);

            if (state is FavoriteEmptyState && userState is UserAuthState) {
              favoriteBloc
                  .add(FavoriteLoadEvent(userId: userState.userData.id));
              return Center(
                child: Text('No cats yet!'),
              );
            }

            if (state is FavoriteLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is FavoriteLoadedState && userState is UserAuthState) {
              void loadMore(page) {
                FavoriteBloc favoriteBloc =
                    BlocProvider.of<FavoriteBloc>(context);
                favoriteBloc.add(FavoriteLoadEvent(
                    userId: userState.userData.id, page: page + 1));
              }

              return BlocProvider<FavoriteBloc>(
                create: (context) => FavoriteBloc(),
                child: Container(
                  child: CatList(
                    cats: state.cats,
                    page: state.page,
                    loadMore: loadMore,
                  ),
                ),
              );
            }

            if (state is FavoriteErrorState) {
              return Center(
                child: Text('Error cat fetching!'),
              );
            }

            return SizedBox();
          });
        },
      ),
    );
  }
}
