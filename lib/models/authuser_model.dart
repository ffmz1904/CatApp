import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final dynamic id;
  final String? name;
  final String? image;
  final String? email;

  AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  factory AuthUser.fromFirebaseCredential(UserCredential credential) {
    return AuthUser(
      id: credential.user?.uid,
      name: credential.user?.displayName!,
      email: credential.user?.email!,
      image: credential.user?.photoURL!,
    );
  }
}
