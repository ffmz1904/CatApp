import 'package:cat_app/authentication/model/auth_user_model.dart';

abstract class UserEvent {}

class UserGetCacheDataEvent extends UserEvent {}

class UserLoginEvent extends UserEvent {
  AuthProviders authProvider;

  UserLoginEvent({required this.authProvider});
}

class UserLogoutEvent extends UserEvent {
  AuthProviders authProvider;

  UserLogoutEvent({required this.authProvider});
}
