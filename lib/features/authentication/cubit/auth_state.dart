import 'package:cat_app/features/authentication/model/auth_user_model.dart';

abstract class AuthState {}

class AuthUnauthorizedState extends AuthState {}

class AuthAuthorizedState extends AuthState {
  AuthUserModel userData;
  AuthAuthorizedState({required this.userData});
}

class AuthErrorState extends AuthState {}
