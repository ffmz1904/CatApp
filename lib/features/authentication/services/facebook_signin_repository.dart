import 'package:cat_app/features/authentication/services/facebook_signin_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FacebookSignInRepository {
  final FacebookSignInProvider _provider = FacebookSignInProvider();

  Future<UserCredential?> login() => _provider.signIn();
  Future<void> logout() => _provider.logout();
}
