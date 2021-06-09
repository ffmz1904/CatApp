import 'package:cat_app/bloc/user/user_bloc.dart';

abstract class UserEvent {}

class UserLoginEvent extends UserEvent {
  UserAuthTypes type;
  UserLoginEvent({required this.type});
}

class UserLogoutEvent extends UserEvent {
  UserAuthTypes type;
  UserLogoutEvent({required this.type});
}
