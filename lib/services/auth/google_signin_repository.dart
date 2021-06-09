import 'package:cat_app/services/auth/google_signin_provider.dart';

class GoogleSignInRepository {
  GoogleSignInProvider _provider = GoogleSignInProvider();

  Future login() => _provider.googleLogin();
  Future logout() => _provider.googleLogout();
}
