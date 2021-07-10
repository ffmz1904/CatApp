import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class FacebookSignInProvider {
  final _auth = FirebaseAuth.instance;

  Stream get currentUser => _auth.authStateChanges();

  Future signIn() async {
    try {
      final fb = FacebookLogin();

      final res = await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email
      ]);

      switch (res.status) {
        case FacebookLoginStatus.success:
          print('success');
          final fbToken = res.accessToken;
          final token = fbToken?.token;
          final AuthCredential credential =
              FacebookAuthProvider.credential(token!);

          return await _auth.signInWithCredential(credential);
        case FacebookLoginStatus.cancel:
          print('cancel');
          break;
        case FacebookLoginStatus.error:
          print('Error');
          break;
      }
    } catch (e) {
      return null;
    }
  }

  Future logout() => _auth.signOut();
}
