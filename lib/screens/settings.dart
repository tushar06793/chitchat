import 'package:chitchat/models/user.dart';

import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final LocalUser user;
  final bool isAdmin;
  SettingsScreen({required this.user, required this.isAdmin});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListTile(
        contentPadding: EdgeInsets.only(left: 10, right: 7),
        leading: CircleAvatar(
          backgroundImage: AssetImage(user.profile),
        ),
        title: Text(
          user.username,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Hey There! I am using whatsApp"),
      ),
    );
  }
}
