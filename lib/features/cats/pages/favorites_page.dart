import 'package:cat_app/features/cats/cubit/cat/cat_state.dart';
import 'package:cat_app/features/cats/cubit/favorite/favorite_cubit.dart';
import 'package:cat_app/features/cats/cubit/favorite/favorite_state.dart';
import 'package:cat_app/features/cats/repositories/cat_repository.dart';
import 'package:cat_app/features/cats/widgets/cat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const CAT_LIMIT = 5;

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteCatCubit(CatRepository()),
      child: BlocBuilder<FavoriteCatCubit, CatState>(
          builder: (context, favoriteState) {
        FavoriteCatCubit favoriteCubit = context.read<FavoriteCatCubit>();

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
            // favoriteBloc.add(FavoriteCatLoadEvent(
            // userId: (userBloc.state as UserAuthState).userData.id,
            // page: favoriteState.page + 1));
          }

          return Container(
            child: CatList(
              cubit: favoriteCubit,
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
            child: Text(favoriteState.message),
          );
        }

        return SizedBox();
      }),
    );
  }
}
