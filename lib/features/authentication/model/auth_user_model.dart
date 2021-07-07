import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

enum AuthProviders {
  google_auth,
  facebook_auth,
}

class AuthUserModel {
  dynamic id;
  String? name;
  String? email;
  String? photo;
  AuthProviders authProvider;

  AuthUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photo,
    required this.authProvider,
  });

  factory AuthUserModel.fromFirebaseCredential(User? user, UserInfo? userInfo) {
    AuthProviders? loginProvider;

    switch (userInfo?.providerId) {
      case 'google.com':
        loginProvider = AuthProviders.google_auth;
        break;
      case 'facebook.com':
        loginProvider = AuthProviders.facebook_auth;
        break;
    }

    return AuthUserModel(
      id: user?.uid,
      name: user?.displayName,
      email: user?.email,
      photo: user?.photoURL,
      authProvider: loginProvider!,
    );
  }
}
