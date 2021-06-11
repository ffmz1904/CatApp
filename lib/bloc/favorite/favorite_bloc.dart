import 'package:cat_app/bloc/favorite/favorite_events.dart';
import 'package:cat_app/bloc/favorite/favorite_state.dart';
import 'package:cat_app/models/cat_model.dart';
import 'package:cat_app/services/cat/cat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  CatRepository _repository = CatRepository();

  FavoriteBloc() : super(FavoriteEmptyState());

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is FavoriteAddEvent) {
      final response = await _repository.addFavorite(event.imgId, event.userId);
      // todo ...
    } else if (event is FavoriteLoadEvent) {
      yield* _mapFavoriteLoadToState(event);
    }
  }

  Stream<FavoriteState> _mapFavoriteLoadToState(
      FavoriteLoadEvent event) async* {
    if (state is FavoriteEmptyState) {
      yield FavoriteLoadingState();
    }

    int limit = 5;
    int page = event.page;

    try {
      List<Cat> cats = await _repository.getFavorite(event.userId, limit, page);

      if (state is FavoriteLoadedState) {
        List<Cat> catState = (state as FavoriteLoadedState).cats;
        catState.addAll(cats);
        yield FavoriteLoadedState(cats: catState, page: page);
      } else {
        yield FavoriteLoadedState(cats: cats, page: page);
      }
    } catch (e) {
      yield FavoriteErrorState();
    }
  }
}
