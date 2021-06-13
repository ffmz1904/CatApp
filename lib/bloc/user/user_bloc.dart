import 'package:cat_app/bloc/user/user_events.dart';
import 'package:cat_app/bloc/user/user_state.dart';
import 'package:cat_app/helpers/check_internet_connection.dart';
import 'package:cat_app/models/auth_user_model.dart';
import 'package:cat_app/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserRepository repository = UserRepository();

  UserBloc() : super(UserEmptyState());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserGetCacheDataEvent) {
      yield* _mapUserDataFromCache(event);
    } else if (event is UserLoginEvent) {
      yield* _mapUserLoginToState(event);
    } else if (event is UserLogoutEvent) {
      yield* _mapUserLogoutToState(event);
    }
  }

  Stream<UserState> _mapUserLoginToState(UserEvent event) async* {
    yield UserLoadingState();

    final credential =
        await repository.login((event as UserLoginEvent).authProvider);

    if (credential == null) {
      yield UserNotAuthState();
    } else {
      AuthUserModel user = AuthUserModel.fromFirebaseCredential(credential);
      await repository.setUserToCache(user: user);
      yield UserAuthState(userData: user);
    }
  }

  Stream<UserState> _mapUserLogoutToState(UserEvent event) async* {
    await repository.logout((event as UserLogoutEvent).authProvider);
    await repository.clearUserCache();
    yield UserNotAuthState();
  }

  Stream<UserState> _mapUserDataFromCache(UserEvent event) async* {
    final user = await repository.getUserFromCache();

    if (user == null) {
      bool connect = await checkInternetConnection();

      if (connect) {
        yield UserNotAuthState();
      } else {
        yield UserErrorState(
            message: 'No internet connection! Please connect and try again!');
      }
    } else {
      yield UserAuthState(userData: user);
    }
  }
}
