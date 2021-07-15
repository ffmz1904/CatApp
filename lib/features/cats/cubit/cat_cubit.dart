import 'package:cat_app/features/cache/sqlite/cat_sqlite_provider.dart';
import 'package:cat_app/features/cats/cubit/cat_state.dart';
import 'package:cat_app/features/cats/model/cat_model.dart';
import 'package:cat_app/features/cats/repositories/cat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const CAT_LIMIT = 5;

enum CatTypes { common, favorite }

class CatCubit extends Cubit<CatState> {
  final CatRepository dataRepository;

  CatCubit({required this.dataRepository}) : super(CatEmptyState());

  Future<void> loadCats(String userId) async {
    if (state is CatEmptyState) {
      emit(CatLoadingState());
    }


    const defaultCatsPage = 1;
    const defaultFavoritesPage = 0;

    try {
      final loadCats = await dataRepository.getCats(CAT_LIMIT, defaultCatsPage);
      final loadFavorites = await dataRepository.getUserFavorites(
          userId, CAT_LIMIT, defaultFavoritesPage);

      await _saveCatLocal(loadCats, loadFavorites);

      emit(CatLoadedState(
        catsList: loadCats,
        favoritesList: loadFavorites,
        catsPage: defaultCatsPage,
        favoritesPage: defaultFavoritesPage,
      ));
    } catch (e, stack) {
      print(stack);
      print(e);
      emit(CatErrorState(message: 'Data fetching error!'));

      final localData = await _getLocalCats();

      if (localData != null) {
        emit(CatLoadedState(
          catsList: localData['common']!,
          favoritesList: localData['favorite']!,
        ));
      }
    }
  }

  Future<void> loadMoreCats(CatTypes type, [String? userId]) async {
    final stateData = (state as CatLoadedState);
    var loadedCats = <CatModel>[];

    try {
      switch (type) {
        case CatTypes.common:
          loadedCats = await dataRepository.getCats(
            CAT_LIMIT,
            stateData.catsPage + 1,
          );

          final updatedCats = stateData.catsList;
          updatedCats.addAll(loadedCats);

          await _saveCatLocal(updatedCats, stateData.favoritesList);

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

          loadedCats = await dataRepository.getUserFavorites(
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
            await _saveCatLocal(stateData.catsList, updatedFavorites);

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

      final localData = await _getLocalCats();

      if (localData != null) {
        emit(CatLoadedState(
          catsList: localData['common']!,
          favoritesList: localData['favorite']!,
        ));
      }
    }
  }

  Future<void> addFavorite(CatModel cat, String userId) async {
    try {
      final stateData = (state as CatLoadedState);
      final response =
          await dataRepository.addToFavorite(cat.id.toString(), userId);

      if (response['message'] == 'SUCCESS') {
        final newCat = CatModel(
          id: cat.id,
          image: cat.image,
          fact: cat.fact,
          isFavorite: true,
          favoriteId: response['id'],
        );
        final commonCats =
            stateData.catsList.map((c) => c.id != cat.id ? c : newCat).toList();

        var favoriteCats = stateData.favoritesList;

        if (favoriteCats.length < CAT_LIMIT) {
          favoriteCats.add(newCat);
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

  Future<void> removeFromFavorite(dynamic favoriteId) async {
    try {
      final response = await dataRepository.removeFromFavorite(favoriteId);

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

  Future<void> _saveCatLocal(
      List<CatModel> commonCats, List<CatModel> favoriteCats) async {
    final localData = List<CatModel>.from(commonCats);
    localData.addAll(favoriteCats);
    await dataRepository.setCatsToCache(localData);
  }

  Future<Map<String, List<CatModel>>?> _getLocalCats() async {
    var commonCats = <CatModel>[];
    var favoriteCats = <CatModel>[];

    final localData = await dataRepository.getCatsFromCache();

    if (localData != null) {
      localData.forEach((cat) {
            if (cat.isFavorite) {
              favoriteCats.add(cat);
            } else {
              commonCats.add(cat);
            }
          });

      return {'common': commonCats, 'favorite': favoriteCats};
    }

    return null;
  }

  @override
  Future<void> close() {
    dataRepository.closeCacheConnection();
    return super.close();
  }
}
