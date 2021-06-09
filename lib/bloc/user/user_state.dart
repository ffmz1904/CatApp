import 'package:cat_app/models/user_model.dart';

abstract class UserState {}

class UserNotAuthState extends UserState {}

class UserAuthState extends UserState {
  User userData;
  UserAuthState({required this.userData});
}

class UserErrorState extends UserState {}
