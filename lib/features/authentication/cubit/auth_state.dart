import 'package:cat_app/features/authentication/model/auth_user_model.dart';

abstract class AuthState {
  String get userId => '';
}

class AuthUnauthorizedState extends AuthState {}

class AuthAuthorizedState extends AuthState {
  AuthUserModel userData;

  AuthAuthorizedState({ required this.userData });

  @override
  String get userId => userData.id;
}

class AuthErrorState extends AuthState {
  String message;
  AuthErrorState({this.message = 'Auth Error!'});
}
