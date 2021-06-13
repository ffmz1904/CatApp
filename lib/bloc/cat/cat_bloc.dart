import 'package:cat_app/bloc/cat/cat_events.dart';
import 'package:cat_app/bloc/cat/cat_state.dart';
import 'package:cat_app/models/cat_model.dart';
import 'package:cat_app/repositories/cat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatBloc extends Bloc<CatEvent, CatState> {
  CatRepository repository = CatRepository();

  CatBloc() : super(CatEmptyState());

  @override
  Stream<CatState> mapEventToState(CatEvent event) async* {
    if (event is CatLoadEvent) {
      yield* _mapCatLoadToState(event);
    } else if (event is CatAddToFavoriteEvent) {
      yield* _mapCatAddFavoriteToState(event);
    } else if (event is CatRemoveFromFavoritesEvent) {
      yield* _mapCatRemoveFromFavoritesToState(event);
    }
  }

  Stream<CatState> _mapCatLoadToState(CatEvent event) async* {
    if (state is CatEmptyState) {
      yield CatLoadingState();
    }

    int limit = 5;
    int page = (event as CatLoadEvent).page;

    try {
      List<CatModel> cats;
      List<CatModel> loadedCats = await repository.getCats(limit, page);

      if (page != 1) {
        cats = (state as CatLoadedState).catList;
        cats.addAll(loadedCats);
      } else {
        cats = loadedCats;
      }

      bool setToLocal =
          await repository.setCatLocal(catList: cats, type: CatTypes.cats);

      if (setToLocal) {
        yield CatLoadedState(catList: cats, page: page);
      }
    } catch (e) {
      print(e);
      List<CatModel>? cats = await repository.getCatLocal(type: CatTypes.cats);
      if (cats == null) {
        yield CatEmptyState();
      } else {
        yield CatLoadedState(catList: cats);
      }
    }
  }

  Stream<CatState> _mapCatAddFavoriteToState(CatEvent event) async* {
    CatAddToFavoriteEvent eventData = (event as CatAddToFavoriteEvent);
    try {
      final response =
          await repository.addToFavorite(eventData.catId, eventData.userId);
      print(response);
      if (response['message'] == 'SUCCESS') {
        List<CatModel> cats = (state as CatLoadedState)
            .catList
            .map((cat) => cat.id != eventData.catId
                ? cat
                : CatModel(
                    id: cat.id,
                    image: cat.image,
                    fact: cat.fact,
                    isFavorite: true,
                    favoriteId: response['id']))
            .toList();

        yield CatLoadedState(
            catList: cats, page: (state as CatLoadedState).page);
      }
    } catch (e) {}
  }

  Stream<CatState> _mapCatRemoveFromFavoritesToState(CatEvent event) async* {
    final eventData = (event as CatRemoveFromFavoritesEvent);

    if (eventData.favoriteBlocEvent) {
      List<CatModel> cats = (state as CatLoadedState)
          .catList
          .map((cat) => cat.favoriteId != eventData.favoriteId
              ? cat
              : CatModel(
                  id: cat.id,
                  image: cat.image,
                  fact: cat.fact,
                  isFavorite: false,
                  favoriteId: null))
          .toList();
      yield CatLoadedState(catList: cats, page: (state as CatLoadedState).page);
    } else {
      final response =
          await repository.removeFromFavorite(eventData.favoriteId);

      if (response['message'] == 'SUCCESS') {
        List<CatModel> cats = (state as CatLoadedState)
            .catList
            .map((cat) => cat.favoriteId != eventData.favoriteId
                ? cat
                : CatModel(
                    id: cat.id,
                    image: cat.image,
                    fact: cat.fact,
                    isFavorite: false,
                    favoriteId: null))
            .toList();
        yield CatLoadedState(
            catList: cats, page: (state as CatLoadedState).page);
      }
    }
  }
}
