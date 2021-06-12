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

      bool setToLocal = await repository.setCatLocal(catList: cats);

      if (setToLocal) {
        yield CatLoadedState(catList: cats, page: page);
      }
    } catch (e) {
      print(e);
      List<CatModel>? cats = await repository.getCatLocal();
      if (cats == null) {
        yield CatEmptyState();
      } else {
        yield CatLoadedState(catList: cats);
      }
    }
  }
}
