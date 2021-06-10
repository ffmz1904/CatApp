import 'package:cat_app/bloc/favorite/favorite_events.dart';
import 'package:cat_app/bloc/favorite/favorite_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteEmptyState());

  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) {
    throw UnimplementedError();
  }
}
