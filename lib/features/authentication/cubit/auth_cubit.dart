import 'package:cat_app/features/authentication/cubit/auth_state.dart';
import 'package:cat_app/features/authentication/model/auth_user_model.dart';
import 'package:cat_app/features/authentication/repositories/authentication_repository.dart';
import 'package:cat_app/helpers/check_internet_connection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthenticationRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthUnauthorizedState());

  Future login(authProvider) async {
    try {
      final internetConnection = await checkInternetConnection();

      if (!internetConnection) {
        return emit(AuthErrorState(message: 'No internet connection!'));
      }

      final credential = await authRepository.login(authProvider);

      if (credential == null) {
        emit(AuthUnauthorizedState());
      } else {
        final User? userData = credential?.user;
        UserInfo? userInfo = userData?.providerData[0];

        final user = AuthUserModel.fromFirebaseCredential(userData, userInfo);
        emit(AuthAuthorizedState(userData: user));
      }
    } catch (e) {
      emit(AuthErrorState(message: 'Login Error!'));
    }
  }

  Future logout(authProvider) async {
    await authRepository.logout(authProvider);
    emit(AuthUnauthorizedState());
  }

  Future setCachedData(User? userData, UserInfo? userInfo) async {
    final user = AuthUserModel.fromFirebaseCredential(userData, userInfo);
    emit(AuthAuthorizedState(userData: user));
  }
}
