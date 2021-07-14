import 'package:cat_app/features/authentication/services/google_signin_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInRepository {
  final GoogleSignInProvider _provider = GoogleSignInProvider();

  Future<UserCredential?> login() => _provider.googleLogin();
  Future<void> logout() => _provider.googleLogout();
}
