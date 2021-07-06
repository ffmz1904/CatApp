import 'package:cat_app/features/cats/model/cat_model.dart';

abstract class CatState {}

class CatEmptyState extends CatState {}

class CatLoadingState extends CatState {}

class CatLoadedState extends CatState {
  List<CatModel> catList;
  int page;

  CatLoadedState({
    required this.catList,
    this.page = 1,
  });
}

class CatErrorState extends CatState {}
