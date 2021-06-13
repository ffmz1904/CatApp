abstract class CatEvent {}

class CatLoadEvent extends CatEvent {
  int page;

  CatLoadEvent({this.page = 1});
}

class CatAddToFavoriteEvent extends CatEvent {
  String userId;
  String catId;
  CatAddToFavoriteEvent({required this.catId, required this.userId});
}

class CatRemoveFromFavoritesEvent extends CatEvent {
  dynamic favoriteId;
  bool favoriteBlocEvent;

  CatRemoveFromFavoritesEvent(
      {required this.favoriteId, this.favoriteBlocEvent = false});
}
