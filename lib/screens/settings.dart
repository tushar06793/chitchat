import 'package:chitchat/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final LocalUser user;
  final bool isAdmin;
  SettingsScreen({required this.user, required this.isAdmin});

  @override
  _SettingsScreenState createState() =>
      _SettingsScreenState(user: user, isAdmin: isAdmin);
}

class _SettingsScreenState extends State<SettingsScreen> {
  final LocalUser user;
  final bool isAdmin;
  final _newUsername = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  _SettingsScreenState({required this.user, required this.isAdmin});
  void setUsername(String username) async {
    await _firestore
        .collection("users")
        .doc(user.phone)
        .update({"name": username});
  }

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
        trailing: IconButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Edit Name'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            controller: _newUsername,
                            keyboardType: TextInputType.text,
                          )
                        ],
                      ),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: Text('Back'),
                          textColor: Colors.white,
                          color: Colors.blue,
                        ),
                        FlatButton(
                          onPressed: () => setUsername(_newUsername.text),
                          child: Text('Change'),
                          textColor: Colors.white,
                          color: Colors.blue,
                        )
                      ],
                    );
                  });
            },
            icon: Icon(Icons.edit)),
      ),
    );
  }
}
