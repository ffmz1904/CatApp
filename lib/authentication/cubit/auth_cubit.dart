import 'package:cat_app/authentication/cubit/auth_state.dart';
import 'package:cat_app/authentication/model/auth_user_model.dart';
import 'package:cat_app/authentication/repositories/authentication_repository.dart';
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
        emit(AuthAuthorizedState(userData: user));
      }
    } catch (e) {
      emit(AuthErrorState());
    }
  }

  Future logout(authProvider) async {
    try {
      await authRepository.logout(authProvider);
      // cache clear
      emit(AuthUnauthorizedState());
    } catch (e) {
      emit(AuthErrorState());
    }
  }
}
