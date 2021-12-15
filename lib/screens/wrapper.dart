import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chitchat/models/user.dart';
import 'package:chitchat/screens/authenticate/login.dart';
import 'package:chitchat/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(user == null){
      return LoginScreen();
    } else {
      return HomeScreen(user: user);
    }
  }
}