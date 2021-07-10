import 'package:cat_app/features/authentication/services/google_signin_provider.dart';

class GoogleSignInRepository {
  final GoogleSignInProvider _provider = GoogleSignInProvider();

  Future login() => _provider.googleLogin();
  Future logout() => _provider.googleLogout();
}
