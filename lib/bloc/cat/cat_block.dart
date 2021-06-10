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
      if (event.cats == null) {
        yield CatLoadingState();
      }

      int limit = 5;
      int page = event.page;

      try {
        List<Cat> cats = await _repository.getCats(limit, page);

        if (event.cats != null) {
          List<Cat> catState = event.cats!;
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
}
