import 'package:cat_app/features/authentication/services/facebook_signin_provider.dart';

class FacebookSignInRepository {
  final FacebookSignInProvider _provider = FacebookSignInProvider();

  Future login() => _provider.signIn();
  Future logout() => _provider.logout();
}
