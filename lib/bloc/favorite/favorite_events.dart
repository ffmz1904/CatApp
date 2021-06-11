abstract class FavoriteEvent {}

class FavoriteLoadEvent extends FavoriteEvent {
  String userId;
  int page;
  FavoriteLoadEvent({required this.userId, this.page = 0});
}

class FavoriteAddEvent extends FavoriteEvent {
  String imgId;
  String userId;

  FavoriteAddEvent({required this.imgId, required this.userId});
}

class FavoriteRemoveEvent extends FavoriteEvent {}
