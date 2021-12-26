import 'package:chitchat/services/auth.dart';
import 'package:flutter/material.dart';
import 'authenticate/login.dart';
import 'home/home.dart';

class Wrapper extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    if (_auth.getUser() != null) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}