import 'package:cat_app/core/widgets/error_dialog.dart';
import 'package:cat_app/features/cats/cubit/cat_cubit.dart';
import 'package:cat_app/features/cats/cubit/cat_state.dart';
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
            pageType: CatTypes.common,
            catList: state.catsList,
            loadMore: () =>
                context.read<CatCubit>().loadMoreCats(CatTypes.common),
            limit: CAT_LIMIT,
          );
        }

        return const SizedBox();
      },
    );
  }
}
