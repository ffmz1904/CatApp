import 'package:cat_app/models/cat_model.dart';

abstract class CatState {}

class CatEmptyState extends CatState {}

class CatLoadingState extends CatState {}

class CatLoadedState extends CatState {
  List<Cat> cats;

  CatLoadedState({required this.cats});
}

class CatErrorState extends CatState {}
