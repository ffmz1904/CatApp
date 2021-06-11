import 'package:cat_app/bloc/cat/cat_events.dart';
import 'package:cat_app/bloc/cat/cat_state.dart';
import 'package:cat_app/models/cat_model.dart';
import 'package:cat_app/services/cat/cat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatBloc extends Bloc<CatEvent, CatState> {
  CatRepository _repository = CatRepository();

  CatBloc() : super(CatEmptyState());

  @override
  Stream<CatState> mapEventToState(CatEvent event) async* {
    if (event is CatLoadEvent) {
      yield* _mapCatLoadedToState(event);
    }
  }

  Stream<CatState> _mapCatLoadedToState(CatLoadEvent event) async* {
    if (state is CatEmptyState) {
      yield CatLoadingState();
    }

    int limit = 5;
    int page = event.page;

    try {
      List<Cat> cats = await _repository.getCats(limit, page);

      if (state is CatLoadedState) {
        List<Cat> catState = (state as CatLoadedState).cats;
        catState.addAll(cats);
        yield CatLoadedState(cats: catState, page: page);
      } else {
        yield CatLoadedState(cats: cats, page: page);
      }
    } catch (e) {
      yield CatErrorState();
    }
  }
}
