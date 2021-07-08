import 'package:cat_app/features/authentication/cubit/auth_cubit.dart';
import 'package:cat_app/features/authentication/cubit/auth_state.dart';
import 'package:cat_app/features/cats/cubit/cat/cat_state.dart';
import 'package:cat_app/features/cats/cubit/favorite/favorite_cubit.dart';
import 'package:cat_app/features/cats/cubit/favorite/favorite_state.dart';
import 'package:cat_app/features/cats/widgets/cat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const CAT_LIMIT = 5;

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoriteCatCubit, CatState>(
        builder: (context, favoriteState) {
      final favoriteCubit = context.read<FavoriteCatCubit>();
      final authCubit = context.read<AuthCubit>();

      if (favoriteState is FavoriteCatEmptyState) {
        // favoriteCubit.loadFavorites(
        //     (authCubit.state as AuthAuthorizedState).userData.id);
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
        return Container(
          child: CatList(
            cubit: favoriteCubit,
            catList: favoriteState.catList
                .where((cat) => cat.favoriteId != null)
                .toList(),
            loadMore: () => favoriteCubit.loadFavorites(
                (authCubit.state as AuthAuthorizedState).userData.id,
                favoriteState.page + 1),
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
    });
  }
}
