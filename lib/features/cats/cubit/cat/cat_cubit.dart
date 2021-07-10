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
          final page = stateData.favoritesList.length % CAT_LIMIT == 0
              ? stateData.favoritesPage + 1
              : stateData.favoritesPage;

          loadedCats = await catRepository.getUserFavorites(
            userId!,
            CAT_LIMIT,
            page,
          );

          var updatedFavorites = stateData.favoritesList;

          if (page != stateData.favoritesPage) {
            updatedFavorites.addAll(loadedCats);
          } else {
            updatedFavorites =
                updatedFavorites.sublist(0, page * CAT_LIMIT).toList();
            updatedFavorites.addAll(loadedCats);
          }

          if (loadedCats.isNotEmpty) {
            return emit(CatLoadedState(
              catsList: stateData.catsList,
              favoritesList: updatedFavorites,
              catsPage: stateData.catsPage,
              favoritesPage: page,
            ));
          }

          return emit(CatLoadedState(
            catsList: stateData.catsList,
            favoritesList: stateData.favoritesList,
            catsPage: stateData.catsPage,
            favoritesPage: stateData.favoritesPage,
          ));
      }
    } catch (e) {
      emit(CatErrorState(message: 'Data fetching error!'));
    }
  }

  Future addFavorite(catId, userId) async {
    try {
      final stateData = (state as CatLoadedState);
      final response = await catRepository.addToFavorite(catId, userId);

      if (response['message'] == 'SUCCESS') {
        CatModel? newCat;
        final commonCats = stateData.catsList.map((cat) {
          if (cat.id != catId) {
            return cat;
          } else {
            newCat = CatModel(
              id: cat.id,
              image: cat.image,
              fact: cat.fact,
              isFavorite: true,
              favoriteId: response['id'],
            );
            return newCat!;
          }
        }).toList();

        var favoriteCats = stateData.favoritesList;

        if (favoriteCats.length < CAT_LIMIT) {
          //   // favoriteCats =
          //   //     await catRepository.getUserFavorites(userId, CAT_LIMIT);
          favoriteCats.add(newCat!);
        }

        emit(CatLoadedState(
          catsList: commonCats,
          favoritesList: favoriteCats,
          catsPage: stateData.catsPage,
          favoritesPage: stateData.favoritesPage,
        ));
      } else {
        throw Error();
      }
    } catch (e) {
      emit(CatErrorState(message: 'Failed adding to favorite!'));
    }
  }

  Future removeFromFavorite(favoriteId) async {
    try {
      final response = await catRepository.removeFromFavorite(favoriteId);

      if (response['message'] == 'SUCCESS') {
        final stateData = (state as CatLoadedState);

        final commonCats = stateData.catsList
            .map((cat) => cat.favoriteId != favoriteId
                ? cat
                : CatModel(
                    id: cat.id,
                    image: cat.image,
                    fact: cat.fact,
                    isFavorite: false,
                    favoriteId: null,
                  ))
            .toList();

        final favoriteCats = stateData.favoritesList
            .where((cat) => cat.favoriteId != favoriteId)
            .toList();

        final fullyFavoritePages = favoriteCats.length ~/ CAT_LIMIT - 1;

        return emit(CatLoadedState(
          catsList: commonCats,
          favoritesList: favoriteCats,
          catsPage: stateData.catsPage,
          favoritesPage: fullyFavoritePages < 0 ? 0 : fullyFavoritePages,
        ));
      } else {
        throw Error();
      }
    } catch (e) {
      emit(CatErrorState(message: 'Remove from favorite failed!'));
    }
  }

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
