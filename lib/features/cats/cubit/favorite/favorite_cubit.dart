import 'package:cat_app/features/cats/cubit/cat/cat_state.dart';
import 'package:cat_app/features/cats/cubit/favorite/favorite_state.dart';
import 'package:cat_app/features/cats/repositories/cat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCatCubit extends Cubit<CatState> {
  CatRepository catRepository;

  FavoriteCatCubit(this.catRepository) : super(FavoriteCatEmptyState());
}
