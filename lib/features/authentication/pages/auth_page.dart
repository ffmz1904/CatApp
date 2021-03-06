import 'package:cat_app/core/widgets/error_dialog.dart';
import 'package:cat_app/features/authentication/cubit/auth_cubit.dart';
import 'package:cat_app/features/authentication/cubit/auth_state.dart';
import 'package:cat_app/features/authentication/model/auth_user_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat App',
      home: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return ErrorDialog(message: state.message);
              },
            );
          }
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select login method',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 320,
              ),
              _LoginBtn(
                label: 'Sign in with Google',
                icon: FaIcon(FontAwesomeIcons.google, color: Colors.white),
                loginFunc: () =>
                    context.read<AuthCubit>().login(AuthProviders.google_auth),
              ),
              SizedBox(
                height: 25,
              ),
              _LoginBtn(
                label: 'Sign in with Facebook',
                icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.white),
                loginFunc: () => context
                    .read<AuthCubit>()
                    .login(AuthProviders.facebook_auth),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginBtn extends StatelessWidget {
  final String label;
  final Widget icon;
  final Function loginFunc;

  _LoginBtn({
    required this.label,
    required this.icon,
    required this.loginFunc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: ElevatedButton.icon(
        onPressed: () {
          loginFunc();
        },
        icon: icon,
        label: Text(label),
      ),
    );
  }
}
