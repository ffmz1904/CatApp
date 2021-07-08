import 'package:cat_app/features/cats/cubit/cat/cat_state.dart';
import 'package:cat_app/features/cats/cubit/favorite/favorite_state.dart';
import 'package:cat_app/features/cats/model/cat_model.dart';
import 'package:cat_app/features/cats/repositories/cat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCatCubit extends Cubit<CatState> {
  CatRepository catRepository;

  FavoriteCatCubit(this.catRepository) : super(FavoriteCatEmptyState());

  Future loadFavorites(String userId, [int page = 0]) async {
    if (state is FavoriteCatEmptyState) {
      emit(FavoriteCatLoadingState());
    }

    final limit = 5;

    try {
      List<CatModel> cats;
      final loadedCats =
          await catRepository.getUserFavorites(userId, limit, page);

      if (page != 0) {
        cats = (state as FavoriteCatLoadedState).catList;
        cats.addAll(loadedCats);
      } else {
        cats = loadedCats;
      }

      if (cats.isNotEmpty) {
        await catRepository.setCatLocal(catList: cats, type: CatTypes.favorite);
        emit(FavoriteCatLoadedState(catList: cats, page: page));
      } else {
        emit(FavoriteCatEmptyState());
      }
    } catch (e) {
      print(e);
      final cats = await catRepository.getCatLocal(type: CatTypes.favorite);
      if (cats == null) {
        emit(FavoriteCatErrorState(message: 'Error fatching data!'));
      } else {
        emit(FavoriteCatLoadedState(catList: cats));
      }
    }
  }

  Future addToFavorite(catId, userId) async {
    final stateData = (state as FavoriteCatLoadedState);
    final response = await catRepository.addToFavorite(catId, userId);

    if (response['message'] == 'SUCCESS') {
      final catList = stateData.catList
          .map((cat) => cat.id != catId
              ? cat
              : CatModel(
                  id: cat.id,
                  image: cat.image,
                  fact: cat.fact,
                  isFavorite: true,
                  favoriteId: response['id'],
                ))
          .toList();

      emit(FavoriteCatLoadedState(catList: catList, page: stateData.page));
    }
  }

  Future removeFavorite(
    favoriteId,
  ) async {
    final stateData = (state as FavoriteCatLoadedState);

    final response = await catRepository.removeFromFavorite(favoriteId);

    if (response['message'] == 'SUCCESS') {
      final catList = stateData.catList
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

      var isEmpty = true;

      for (var i = 0; i < catList.length; i++) {
        if (catList[i].favoriteId != null) {
          isEmpty = false;
          break;
        }
      }

      if (isEmpty) {
        emit(FavoriteCatEmptyState());
      } else {
        emit(FavoriteCatLoadedState(catList: catList, page: stateData.page));
      }
    }
  }
}
