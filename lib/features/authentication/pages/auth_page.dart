import 'package:cat_app/features/authentication/cubit/auth_cubit.dart';
import 'package:cat_app/features/authentication/cubit/auth_state.dart';
import 'package:cat_app/features/authentication/model/auth_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return MaterialApp(
      title: 'Cat App',
      home: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: Text(
                      'Error',
                      textAlign: TextAlign.center,
                    ),
                    content: Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                  );
                });
          }
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Select login method',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 220,
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          authCubit.login(AuthProviders.google_auth);
                        },
                        icon: FaIcon(FontAwesomeIcons.google,
                            color: Colors.white),
                        label: Text('Sign in with Google'),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 220,
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          authCubit.login(AuthProviders.facebook_auth);
                        },
                        icon: FaIcon(FontAwesomeIcons.facebook,
                            color: Colors.white),
                        label: Text('Sign in with Facebook'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
