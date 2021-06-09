import 'package:cat_app/services/auth/facebook_signin_provider.dart';

class FacebookSignInRepository {
  FacebookSignInProvider _provider = FacebookSignInProvider();

  Future login() => _provider.signIn();
  Future logout() => _provider.logout();
}
