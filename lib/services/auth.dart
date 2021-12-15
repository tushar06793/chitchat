import 'package:chitchat/models/user.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static String name = "Random";

  // cast Firebase User to custom user class
  User? _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid, username: name, phone: user.phoneNumber) : null;
  }

  // Authchange user stream
  Stream<User?> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // sign in anom
  Future signInAnom() async {
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  // sign in with phone number
  Future signInWithPhoneNumber(String number, BuildContext context) async {

    final _codeController = TextEditingController();

    await _auth.verifyPhoneNumber(
      phoneNumber: '+91'+number,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (AuthException exception) {
        // Navigator.of(context).pop();
        print(exception);
        return null;
      },
      codeSent: (String verificationId, [int? forceResendingToken]){
        showDialog(context: context, barrierDismissible: false, builder: (context) {
          return AlertDialog(
            title: Text('Provide Code'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _codeController,
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () async {
                  AuthCredential credential = PhoneAuthProvider.getCredential(
                    verificationId: verificationId,
                    smsCode: _codeController.text.trim(),
                  );
                  await _auth.signInWithCredential(credential);
                },
                child: Text('Confirm'),
                textColor: Colors.white,
                color: Colors.blue,
              )
            ],
          );
        });
      },
      codeAutoRetrievalTimeout: null,
    );
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

}