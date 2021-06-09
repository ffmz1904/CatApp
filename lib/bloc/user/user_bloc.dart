import 'package:cat_app/bloc/user/user_events.dart';
import 'package:cat_app/bloc/user/user_state.dart';
import 'package:cat_app/services/auth/facebook_signin_provider.dart';
import 'package:cat_app/services/auth/google_signin_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserNotAuthState());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserLoginWithGoogleEvent) {
      GoogleSignInRepository google = GoogleSignInRepository();
      google.login();
    }

    if (event is UserLoginWithFacebookEvent) {
      final authService = FacebookSignInProvider();
      final fb = FacebookLogin();

      final res = await fb.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email
      ]);

      switch (res.status) {
        case FacebookLoginStatus.success:
          print('success');
          final FacebookAccessToken? fbToken = res.accessToken;

          final token = fbToken?.token;
          final AuthCredential credential =
              FacebookAuthProvider.credential(token!);

          final result = authService.signIn(credential);

          // authService.logout();
          break;
        case FacebookLoginStatus.cancel:
          print('cancel');
          break;
        case FacebookLoginStatus.error:
          print('Error');
          break;
      }
    }

    if (event is UserLogoutEvent) {
      GoogleSignInRepository google = GoogleSignInRepository();
      google.logout();
    }
  }
}
