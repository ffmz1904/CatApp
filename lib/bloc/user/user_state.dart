import 'package:cat_app/models/auth_user_model.dart';

abstract class UserState {}

class UserEmptyState extends UserState {}

class UserNotAuthState extends UserState {}

class UserLoadingState extends UserState {}

class UserAuthState extends UserState {
  AuthUserModel userData;

  UserAuthState({required this.userData});
}

class UserErrorState extends UserState {}
