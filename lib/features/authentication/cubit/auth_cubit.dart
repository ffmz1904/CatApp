import 'package:cat_app/features/authentication/cubit/auth_state.dart';
import 'package:cat_app/features/authentication/model/auth_user_model.dart';
import 'package:cat_app/features/authentication/repositories/authentication_repository.dart';
import 'package:cat_app/helpers/check_internet_connection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthenticationRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthUnauthorizedState());

  Future login(authProvider) async {
    try {
      emit(AuthInProcessState());

      final credential = await authRepository.login(authProvider);

      if (credential == null) {
        emit(AuthUnauthorizedState());
      } else {
        AuthUserModel user = AuthUserModel.fromFirebaseCredential(credential);
        await authRepository.setAuthDataToCache(user: user);
        emit(AuthAuthorizedState(userData: user));
      }
    } catch (e) {
      emit(AuthErrorState());
    }
  }

  Future logout(authProvider) async {
    try {
      await authRepository.logout(authProvider);
      await authRepository.clearAuthDataCache();
      emit(AuthUnauthorizedState());
    } catch (e) {
      emit(AuthErrorState());
    }
  }

  Future getCachedData() async {
    final user = await authRepository.getAuthDataFromCache();

    if (user == null) {
      bool connect = await checkInternetConnection();

      if (connect) {
        emit(AuthUnauthorizedState());
      } else {
        emit(AuthErrorState());
      }
    } else {
      emit(AuthAuthorizedState(userData: user));
    }
  }
}
