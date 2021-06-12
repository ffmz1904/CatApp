import 'package:cat_app/bloc/cat/cat_events.dart';
import 'package:cat_app/bloc/cat/cat_state.dart';
import 'package:cat_app/bloc/favorite_cat/favorite_cat_events.dart';
import 'package:cat_app/bloc/favorite_cat/favorite_cat_state.dart';
import 'package:cat_app/models/cat_model.dart';
import 'package:cat_app/repositories/cat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCatBloc extends Bloc<CatEvent, CatState> {
  CatRepository repository = CatRepository();

  FavoriteCatBloc() : super(FavoriteCatEmptyState());

  @override
  Stream<CatState> mapEventToState(CatEvent event) async* {
    if (event is FavoriteCatLoadEvent) {
      yield* _mapFavoriteCatLoadToState(event);
    }
  }

  Stream<CatState> _mapFavoriteCatLoadToState(CatEvent event) async* {
    if (state is FavoriteCatEmptyState) {
      yield FavoriteCatLoadingState();
    }

    FavoriteCatLoadEvent eventData = (event as FavoriteCatLoadEvent);

    int limit = 5;
    int page = eventData.page;
    String userId = eventData.userId;

    List<CatModel> cats;
    List<CatModel> loadedCats =
        await repository.getUserFavorites(userId, limit, page);

    if (page != 0) {
      cats = (state as FavoriteCatLoadedState).catList;
      cats.addAll(loadedCats);
    } else {
      cats = loadedCats;
    }

    yield FavoriteCatLoadedState(catList: cats, page: page);
  }
}
