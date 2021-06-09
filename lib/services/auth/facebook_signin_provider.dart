import 'package:firebase_auth/firebase_auth.dart';

class FacebookSignInProvider {
  final _auth = FirebaseAuth.instance;

  Stream get currentUser => _auth.authStateChanges();

  Future signIn(AuthCredential credential) =>
      _auth.signInWithCredential(credential);

  Future<void> logout() => _auth.signOut();
}
