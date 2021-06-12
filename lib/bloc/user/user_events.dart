import 'package:cat_app/models/auth_user_model.dart';

abstract class UserEvent {}

class UserGetCacheDataEvent extends UserEvent {}

class UserLoginEvent extends UserEvent {
  UserAuthProviders authProvider;

  UserLoginEvent({required this.authProvider});
}

class UserLogoutEvent extends UserEvent {
  UserAuthProviders authProvider;

  UserLogoutEvent({required this.authProvider});
}
