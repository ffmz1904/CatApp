import 'package:cat_app/models/auth_user_model.dart';
import 'package:cat_app/services/auth/facebook_signin_repository.dart';
import 'package:cat_app/services/auth/google_signin_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final String localKey = 'USER_DATA_LOCAL';
  GoogleSignInRepository googleRepository = GoogleSignInRepository();
  FacebookSignInRepository facebookRepository = FacebookSignInRepository();

  Future login(UserAuthProviders provider) async {
    UserCredential? credential;

    switch (provider) {
      case UserAuthProviders.google_auth:
        credential = await googleRepository.login();
        break;
      case UserAuthProviders.facebook_auth:
        credential = await facebookRepository.login();
        break;
    }

    return credential;
  }

  Future logout(UserAuthProviders provider) async {
    switch (provider) {
      case UserAuthProviders.google_auth:
        await googleRepository.logout();
        break;
      case UserAuthProviders.facebook_auth:
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
