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

  factory AuthUserModel.fromFirebaseCredential(UserCredential credential) {
    User? user = credential.user;
    AuthCredential? authCredential = credential.credential;
    AuthProviders? loginProvider;

    switch (authCredential?.signInMethod) {
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

  factory AuthUserModel.fromJson(Map<String, dynamic> jsonData) {
    AuthProviders? loginProvider;

    switch (jsonData['authProvider']) {
      case 'google.com':
        loginProvider = AuthProviders.google_auth;
        break;
      case 'facebook.com':
        loginProvider = AuthProviders.facebook_auth;
        break;
    }

    return AuthUserModel(
      id: jsonData['id'],
      name: jsonData['name'],
      email: jsonData['email'],
      photo: jsonData['photo'],
      authProvider: loginProvider!,
    );
  }

  static Map<String, dynamic> toMap(AuthUserModel user) => {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'photo': user.photo,
        'authProvider': user.authProvider == AuthProviders.google_auth
            ? 'google.com'
            : 'facebook.com',
      };

  static String encode(AuthUserModel user) =>
      json.encode(AuthUserModel.toMap(user));

  static AuthUserModel decode(String userDataString) {
    final user = json.decode(userDataString);
    return AuthUserModel.fromJson(user);
  }
}
