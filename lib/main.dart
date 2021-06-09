import 'package:cat_app/pages/auth_page.dart';
import 'package:cat_app/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cat App",
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        "/auth": (context) => AuthPage(),
      },
    );
  }
}
