import 'package:cat_app/bloc/cat/cat_events.dart';

class FavoriteCatLoadEvent extends CatEvent {
  String userId;
  int page;

  FavoriteCatLoadEvent({required this.userId, this.page = 0});
}
