abstract class CatEvent {}

class CatLoadEvent extends CatEvent {
  int page;
  CatLoadEvent({this.page = 1});
}
