import 'package:cat_app/core/widgets/error_dialog.dart';
import 'package:cat_app/features/authentication/cubit/auth_cubit.dart';
import 'package:cat_app/features/cats/cubit/cat/cat_cubit.dart';
import 'package:cat_app/features/cats/cubit/cat/cat_state.dart';
import 'package:cat_app/features/cats/widgets/cat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const CAT_LIMIT = 5;

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CatCubit, CatState>(
      listener: (context, state) {
        if (state is CatErrorState) {
          showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return ErrorDialog(message: state.message);
              });
        }
      },
      builder: (context, state) {
        if (state is CatLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is CatLoadedState) {
          return CatList(
            pageType: CatTypes.favorite,
            catList: state.favoritesList,
            loadMore: () => context.read<CatCubit>().loadMoreCats(
                CatTypes.favorite, context.read<AuthCubit>().userId),
            limit: CAT_LIMIT,
          );
        }

        return const SizedBox();
      },
    );
  }
}
