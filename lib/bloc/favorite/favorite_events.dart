abstract class FavoriteEvent {}

class FavoriteLoadEvent extends FavoriteEvent {}

class FavoriteAddEvent extends FavoriteEvent {
  String imgId;
  String userId;

  FavoriteAddEvent({required this.imgId, required this.userId});
}

class FavoriteRemoveEvent extends FavoriteEvent {}
