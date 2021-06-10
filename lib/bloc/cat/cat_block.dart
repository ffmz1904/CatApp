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
      yield CatLoadingState();

      try {
        List<Cat> cats = await _repository.getCats();
        yield CatLoadedState(cats: cats);
      } catch (e) {
        yield CatErrorState();
      }
    }
  }
}
