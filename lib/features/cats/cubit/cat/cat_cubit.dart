import 'package:cat_app/features/cats/cubit/cat/cat_state.dart';
import 'package:cat_app/features/cats/model/cat_model.dart';
import 'package:cat_app/features/cats/repositories/cat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatCubit extends Cubit<CatState> {
  final CatRepository catRepository;

  CatCubit(this.catRepository) : super(CatEmptyState());

  Future loadCat([int page = 1]) async {
    if (state is CatEmptyState) {
      emit(CatLoadingState());
    }

    int limit = 5;

    try {
      List<CatModel> cats;
      List<CatModel> loadedCats = await catRepository.getCats(limit, page);

      if (page != 1) {
        cats = (state as CatLoadedState).catList;
        cats.addAll(loadedCats);
      } else {
        cats = loadedCats;
      }

      bool setToLocal =
          await catRepository.setCatLocal(catList: cats, type: CatTypes.cats);

      if (setToLocal) {
        emit(CatLoadedState(catList: cats, page: page));
      }
    } catch (e) {
      List<CatModel>? cats =
          await catRepository.getCatLocal(type: CatTypes.cats);
      if (cats == null) {
        emit(CatEmptyState());
      } else {
        emit(CatLoadedState(catList: cats));
      }
    }
  }
}
