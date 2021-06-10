import 'package:cat_app/models/cat_model.dart';

abstract class CatState {}

class CatEmptyState extends CatState {}

class CatLoadingState extends CatState {}

class CatLoadedState extends CatState {
  List<Cat> cats;
  int page;

  CatLoadedState({required this.cats, required this.page});
}

class CatErrorState extends CatState {}
