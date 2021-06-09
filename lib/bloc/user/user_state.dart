import 'package:cat_app/bloc/user/user_bloc.dart';
import 'package:cat_app/models/authuser_model.dart';

abstract class UserState {}

class UserNotAuthState extends UserState {}

class UserAuthState extends UserState {
  UserAuthTypes type;
  AuthUser userData;
  UserAuthState({
    required this.type,
    required this.userData,
  });

  UserAuthTypes get getType => type;
}

class UserErrorState extends UserState {}
