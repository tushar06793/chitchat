import 'dart:io';

import 'package:chitchat/models/user.dart';
import 'package:chitchat/services/auth.dart';
import 'package:chitchat/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class SettingsScreen extends StatefulWidget {
  final LocalUser user;
  final bool isAdmin;

  SettingsScreen({required this.user, required this.isAdmin});

  @override
  _SettingsScreenState createState() =>
      _SettingsScreenState(user: user, isAdmin: isAdmin);
}

class _SettingsScreenState extends State<SettingsScreen> {
  LocalUser user;
  final bool isAdmin;

  final _newUsername = TextEditingController();
  final Service service = Service();
  final AuthService _auth = AuthService();

  File? imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) async {
      if (xFile != null) {
        imageFile = File(xFile.path);
        await user.updateProfile(imageFile!);
        LocalUser updatedUser = await _auth.fetchUser(user);

        setState(() {
          user = updatedUser;
        });
      }
    });
  }

  _SettingsScreenState({required this.user, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.only(top: 10.0)),
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                Padding(padding: const EdgeInsets.only(top: 10.0)),
                CircleAvatar(
                  backgroundImage: NetworkImage(user.profile),
                  radius: 90,
                ),
                Positioned(
                  right: 10,
                  top: 130,
                  child: IconButton(
                      onPressed: () => getImage(),
                      icon: Icon(
                        Icons.camera_alt,
                        size: 40,
                      )),
                )
              ],
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 10, right: 7),
            leading: Icon(
              Icons.account_box,
              size: 40,
            ),
            title: Text(
              "Name",
            ),
            subtitle: Text(user.username,
                style: TextStyle(fontWeight: FontWeight.bold)),
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
                              onPressed: () async {
                                user.username = _newUsername.text.trim();
                                await service.updateName(user);
                              },
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
          ListTile(
            contentPadding: EdgeInsets.only(left: 10, right: 7),
            leading: Icon(
              Icons.call,
              size: 35,
            ),
            title: Text(
              "Phone",
            ),
            subtitle: Text(
              user.phone,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
