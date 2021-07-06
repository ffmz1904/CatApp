import 'package:cat_app/authentication/model/auth_user_model.dart';
import 'package:cat_app/authentication/services/facebook_signin_repository.dart';
import 'package:cat_app/authentication/services/google_signin_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {
  GoogleSignInRepository googleRepository = GoogleSignInRepository();
  FacebookSignInRepository facebookRepository = FacebookSignInRepository();

  Future login(AuthProviders provider) async {
    UserCredential? credential;

    try {
      switch (provider) {
        case AuthProviders.google_auth:
          credential = await googleRepository.login();
          break;
        case AuthProviders.facebook_auth:
          credential = await facebookRepository.login();
          break;
      }

      return credential;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future logout(AuthProviders provider) async {
    switch (provider) {
      case AuthProviders.google_auth:
        await googleRepository.logout();
        break;
      case AuthProviders.facebook_auth:
        await facebookRepository.logout();
        break;
    }
  }
}
