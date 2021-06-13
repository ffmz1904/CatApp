import 'package:cat_app/bloc/user/user_bloc.dart';
import 'package:cat_app/bloc/user/user_events.dart';
import 'package:cat_app/bloc/user/user_state.dart';
import 'package:cat_app/models/auth_user_model.dart';
import 'package:cat_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('We have an error!'),
            );
          } else if (snapshot.hasData) {
            return HomePage();
          } else if (userBloc.state is UserErrorState) {
            String message = (userBloc.state as UserErrorState).message;

            return Center(
              child: Text(message),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Select login method',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton.icon(
                    onPressed: () {
                      userBloc.add(UserLoginEvent(
                          authProvider: UserAuthProviders.google_auth));
                    },
                    icon: FaIcon(FontAwesomeIcons.google, color: Colors.white),
                    label: Text('Sign in with Google'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      userBloc.add(UserLoginEvent(
                          authProvider: UserAuthProviders.facebook_auth));
                    },
                    icon:
                        FaIcon(FontAwesomeIcons.facebook, color: Colors.white),
                    label: Text('Sign in with Facebook'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
