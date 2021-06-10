import 'package:cat_app/models/cat_model.dart';

abstract class CatEvent {}

class CatLoadEvent extends CatEvent {
  int page;
  List<Cat>? cats;
  CatLoadEvent({this.page = 1, this.cats});
}
