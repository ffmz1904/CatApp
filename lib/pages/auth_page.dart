import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select login method',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () {},
              icon: FaIcon(FontAwesomeIcons.google, color: Colors.white),
              label: Text('Sign in with Google'),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {},
              icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.white),
              label: Text('Sign in with Facebook'),
            ),
          ],
        ),
      ),
    );
  }
}
