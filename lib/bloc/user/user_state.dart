import 'package:cat_app/authentication/model/auth_user_model.dart';

abstract class UserState {}

class UserEmptyState extends UserState {}

class UserNotAuthState extends UserState {}

class UserLoadingState extends UserState {}

class UserAuthState extends UserState {
  AuthUserModel userData;

  UserAuthState({required this.userData});
}

class UserErrorState extends UserState {
  String message;
  UserErrorState({this.message = ''});
}
