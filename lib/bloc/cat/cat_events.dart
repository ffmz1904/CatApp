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
