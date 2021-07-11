import 'package:cat_app/features/authentication/cubit/auth_state.dart';
import 'package:cat_app/features/authentication/model/auth_user_model.dart';
import 'package:cat_app/features/authentication/repositories/authentication_repository.dart';
import 'package:cat_app/helpers/check_internet_connection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthenticationRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthUnauthorizedState()) {
    FirebaseAuth.instance.authStateChanges().listen((userData) {
      if (userData == null) {
        return emit(AuthUnauthorizedState());
      }

      final userInfo = userData.providerData[0];
      final user = AuthUserModel.fromFirebaseCredential(userData, userInfo);

      emit(AuthAuthorizedState(userData: user));
    });
  }

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
        final userData = credential?.user;
        final userInfo = userData?.providerData[0];
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

  Future changeCacheProvider(String type) async {
    final stateData = (state as AuthAuthorizedState);
    emit(AuthAuthorizedState(
      userData: stateData.userData,
      cacheProviderType: type,
    ));
  }

  String get userId => (state as AuthAuthorizedState).userData.id;
}
