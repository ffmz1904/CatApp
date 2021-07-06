import 'package:cat_app/authentication/services/facebook_signin_repository.dart';
import 'package:cat_app/authentication/services/google_signin_repository.dart';
import 'package:cat_app/authentication/model/auth_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final String localKey = 'USER_DATA_LOCAL';
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

  Future setUserToCache({required AuthUserModel user}) async {
    SharedPreferences local = await SharedPreferences.getInstance();
    String userDataString = AuthUserModel.encode(user);
    await local.setString(localKey, userDataString);
    print('set user in cache');
    return true;
  }

  Future getUserFromCache() async {
    SharedPreferences local = await SharedPreferences.getInstance();
    String? userDataString = local.getString(localKey);
    print('Get user from cache');
    if (userDataString == null) {
      return null;
    }

    AuthUserModel user = AuthUserModel.decode(userDataString);
    return user;
  }

  Future clearUserCache() async {
    SharedPreferences local = await SharedPreferences.getInstance();
    local.clear();
  }
}
