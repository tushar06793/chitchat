import 'package:chitchat/home.dart';
import 'package:chitchat/login.dart';
import 'package:chitchat/signup.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Color(0xff075e54),
          primaryColorLight: Color(0xff08d261)),
      home: RegistrationScreen(),
      routes: {
        RegistrationScreen.routeName: (ctx) => RegistrationScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
      },
    );
  }
}
