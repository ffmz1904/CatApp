import 'package:cat_app/features/cats/cubit/cat/cat_cubit.dart';
import 'package:cat_app/features/cats/cubit/cat/cat_state.dart';
import 'package:cat_app/features/cats/cubit/favorite/favorite_cubit.dart';
import 'package:cat_app/features/cats/repositories/cat_repository.dart';
import 'package:cat_app/features/cats/widgets/cat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const CAT_LIMIT = 5;

class CatsPage extends StatelessWidget {
  const CatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatCubit, CatState>(builder: (context, catState) {
      CatCubit catCubit = context.read<CatCubit>();
      loadMoreCats() => catCubit.loadCat((catState as CatLoadedState).page + 1);

      if (catState is CatEmptyState) {
        catCubit.loadCat();
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
          cubit: catCubit,
          catList: catState.catList,
          loadMore: loadMoreCats,
          limit: CAT_LIMIT,
        );
      }

      return SizedBox();
    });
    // );
  }
}
