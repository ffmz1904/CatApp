import 'package:cat_app/models/cat_model.dart';

abstract class FavoriteState {}

class FavoriteEmptyState extends FavoriteState {}

class FavoriteLoadingState extends FavoriteState {}

class FavoriteLoadedState extends FavoriteState {
  List<Cat> cats;
  static FavoriteLoadedState? state;

  FavoriteLoadedState({required this.cats});

  factory FavoriteLoadedState.setState(List<Cat> catsList) {
    if (state == null) {
      return FavoriteLoadedState(cats: catsList);
    }

    List<Cat>? newCatsList = state?.cats;
    newCatsList?.addAll(catsList);

    return FavoriteLoadedState(cats: newCatsList!);
  }
}

class FavoriteErrorState extends FavoriteState {}
