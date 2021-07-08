import 'package:cat_app/features/cats/cubit/cat/cat_cubit.dart';
import 'package:cat_app/features/cats/cubit/cat/cat_state.dart';
import 'package:cat_app/features/cats/widgets/cat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const CAT_LIMIT = 5;

class CatsPage extends StatelessWidget {
  const CatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CatCubit, CatState>(
      listener: (context, state) {
        // to do
      },
      builder: (context, state) {
        if (state is CatEmptyState) {
          context.read<CatCubit>().loadCat();
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
          return CatList(
            cubit: context.read<CatCubit>(),
            catList: state.catList,
            loadMore: () => context.read<CatCubit>().loadCat(state.page + 1),
            limit: CAT_LIMIT,
          );
        }

        return const SizedBox();
      },
    );
  }
}
