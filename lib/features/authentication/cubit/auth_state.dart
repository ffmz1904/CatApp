import 'package:cat_app/features/authentication/model/auth_user_model.dart';
import 'package:cat_app/features/cache/cache_provider_types.dart';

abstract class AuthState {}

class AuthUnauthorizedState extends AuthState {}

class AuthAuthorizedState extends AuthState {
  String cacheProviderType;
  AuthUserModel userData;
  AuthAuthorizedState({
    required this.userData,
    this.cacheProviderType = CACHE_SHARED_PREFERENCES,
  });
}

class AuthErrorState extends AuthState {
  String message;
  AuthErrorState({this.message = 'Auth Error!'});
}
