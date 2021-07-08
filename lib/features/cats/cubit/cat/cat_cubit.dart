import 'package:cat_app/features/cats/cubit/cat/cat_state.dart';
import 'package:cat_app/features/cats/model/cat_model.dart';
import 'package:cat_app/features/cats/repositories/cat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const CAT_LIMIT = 5;

enum CatTypes { common, favorite }

class CatCubit extends Cubit<CatState> {
  final CatRepository catRepository;

  CatCubit(this.catRepository) : super(CatEmptyState());

  Future<void> loadCats(userId) async {
    if (state is CatEmptyState) {
      emit(CatLoadingState());
    }

    const defaultCatsPage = 1;
    const defaultFavoritesPage = 0;

    try {
      final loadCats = await catRepository.getCats(CAT_LIMIT, defaultCatsPage);
      final loadFavorites = await catRepository.getUserFavorites(
          userId, CAT_LIMIT, defaultFavoritesPage);

      emit(CatLoadedState(
        catsList: loadCats,
        favoritesList: loadFavorites,
        catsPage: defaultCatsPage,
        favoritesPage: defaultFavoritesPage,
      ));
    } catch (e) {
      emit(CatErrorState(message: 'Data fetching error!'));
    }
  }

  Future<void> loadMoreCats(CatTypes type, [String? userId]) async {
    final stateData = (state as CatLoadedState);
    var loadedCats = <CatModel>[];

    try {
      switch (type) {
        case CatTypes.common:
          loadedCats = await catRepository.getCats(
            CAT_LIMIT,
            stateData.catsPage + 1,
          );

          final updatedCats = stateData.catsList;
          updatedCats.addAll(loadedCats);

          return emit(CatLoadedState(
            catsList: updatedCats,
            favoritesList: stateData.favoritesList,
            catsPage: stateData.catsPage + 1,
            favoritesPage: stateData.favoritesPage,
          ));
        case CatTypes.favorite:
          loadedCats = await catRepository.getUserFavorites(
            userId!,
            CAT_LIMIT,
            stateData.favoritesPage + 1,
          );

          final updatedFavorites = stateData.favoritesList;
          updatedFavorites.addAll(loadedCats);

          return emit(CatLoadedState(
            catsList: stateData.catsList,
            favoritesList: updatedFavorites,
            catsPage: stateData.catsPage + 1,
            favoritesPage: stateData.favoritesPage,
          ));
      }
    } catch (e) {
      emit(CatErrorState(message: 'Data fetching error!'));
    }
  }

  // Future loadCat([int page = 1]) async {
  //   if (page == 1) {
  //     emit(CatLoadingState());
  //   }

  //   final limit = 5;

  //   try {
  //     List<CatModel> cats;
  //     final loadedCats = await catRepository.getCats(limit, page);

  //     if (page != 1) {
  //       cats = (state as CatLoadedState).catList;
  //       cats.addAll(loadedCats);
  //     } else {
  //       cats = loadedCats;
  //     }

  //     final setToLocal =
  //         await catRepository.setCatLocal(catList: cats, type: CatTypes.cats);

  //     if (setToLocal) {
  //       emit(CatLoadedState(
  //         catList: cats,
  //         page: page,
  //       ));
  //     }
  //   } catch (e) {
  //     final cats = await catRepository.getCatLocal(type: CatTypes.cats);
  //     if (cats == null) {
  //       emit(CatEmptyState());
  //     } else {
  //       emit(CatLoadedState(catList: cats));
  //     }
  //   }
  // }

  // Future addFavorite(catId, userId) async {
  //   try {
  //     final response = await catRepository.addToFavorite(catId, userId);

  //     if (response['message'] == 'SUCCESS') {
  //       final cats = (state as CatLoadedState)
  //           .catList
  //           .map((cat) => cat.id != catId
  //               ? cat
  //               : CatModel(
  //                   id: cat.id,
  //                   image: cat.image,
  //                   fact: cat.fact,
  //                   isFavorite: true,
  //                   favoriteId: response['id']))
  //           .toList();

  //       emit(CatLoadedState(
  //           catList: cats, page: (state as CatLoadedState).page));
  //     }
  //   } catch (e) {
  //     //todo: error!
  //   }
  // }

  // Future removeFromFavorites(favoriteId, [favoriteBlocEvent = false]) async {
  //   if (favoriteBlocEvent) {
  //     final cats = (state as CatLoadedState)
  //         .catList
  //         .map((cat) => cat.favoriteId != favoriteId
  //             ? cat
  //             : CatModel(
  //                 id: cat.id,
  //                 image: cat.image,
  //                 fact: cat.fact,
  //                 isFavorite: false,
  //                 favoriteId: null))
  //         .toList();
  //     emit(CatLoadedState(catList: cats, page: (state as CatLoadedState).page));
  //   } else {
  //     final response = await catRepository.removeFromFavorite(favoriteId);

  //     if (response['message'] == 'SUCCESS') {
  //       final cats = (state as CatLoadedState)
  //           .catList
  //           .map((cat) => cat.favoriteId != favoriteId
  //               ? cat
  //               : CatModel(
  //                   id: cat.id,
  //                   image: cat.image,
  //                   fact: cat.fact,
  //                   isFavorite: false,
  //                   favoriteId: null,
  //                 ))
  //           .toList();
  //       emit(CatLoadedState(
  //           catList: cats, page: (state as CatLoadedState).page));
  //     }
  //   }
  // }
}
