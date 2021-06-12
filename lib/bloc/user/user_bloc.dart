import 'package:cat_app/bloc/user/user_events.dart';
import 'package:cat_app/bloc/user/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserNotAuthState());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    throw UnimplementedError();
  }
}
