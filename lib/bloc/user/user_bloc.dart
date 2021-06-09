import 'package:cat_app/bloc/user/user_events.dart';
import 'package:cat_app/bloc/user/user_state.dart';
import 'package:cat_app/models/authuser_model.dart';
import 'package:cat_app/services/auth/facebook_signin_repository.dart';
import 'package:cat_app/services/auth/google_signin_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum UserAuthTypes { Google, Facebook }

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserNotAuthState());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserLoginEvent) {
      dynamic data;

      switch (event.type) {
        case UserAuthTypes.Google:
          GoogleSignInRepository google = GoogleSignInRepository();
          data = await google.login();
          break;
        case UserAuthTypes.Facebook:
          FacebookSignInRepository facebook = FacebookSignInRepository();
          data = await facebook.login();
          break;
      }

      if (data == null) {
        print('Null data');
        yield UserErrorState();
      }
      if (data is UserCredential) {
        yield UserAuthState(
          type: event.type,
          userData: AuthUser.fromFirebaseCredential(data),
        );
      }
    }

    if (event is UserLogoutEvent) {
      switch (event.type) {
        case UserAuthTypes.Google:
          GoogleSignInRepository google = GoogleSignInRepository();
          await google.logout();
          break;
        case UserAuthTypes.Facebook:
          FacebookSignInRepository facebook = FacebookSignInRepository();
          await facebook.logout();
          break;
      }

      yield UserNotAuthState();
    }
  }
}
