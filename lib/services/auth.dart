import 'package:chitchat/models/user.dart';
import 'package:chitchat/screens/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String name = "Random";

  // cast Firebase User to custom user class
  LocalUser? castLocalUser(User user){
    return user != null ? LocalUser(user.uid, name, user.phoneNumber!) : null;
  }

  User? getUser() {
    return _auth.currentUser;
  }

  Future fetchProfile(LocalUser user) async {
    await _firestore.collection('users').doc(user.phone).get().then((snapshot) {
      var data = snapshot.data();
      user.profile = data!["profile"];
    });
  }

  // sign in anom
  Future<User?> signInAnom() async {
    return null;
    // try{
    //   UserCredential userCredential = await _auth.signInAnonymously();
    //   print("Login succesfullly");
    //   return userCredential.user;
    // } catch (e) {
    //   print(e);
    //   return null;
    // }
  }

  // sign in with phone number
  Future signInWithPhoneNumber(String number, BuildContext context) async {

    final _codeController = TextEditingController();
    number = "+91" + number;

    await _auth.verifyPhoneNumber(
      phoneNumber: number,
      timeout: Duration(seconds: 60*2),
      verificationCompleted: (AuthCredential credential) async {
        UserCredential userCredential= await _auth.signInWithCredential(credential);
        userCredential.user!.updateDisplayName(name);

        print("Login successfully");

        await _firestore.collection('users').doc(number).get().then((snapshot) async {
          if(snapshot.exists){
            var data = snapshot.data();
            await _firestore.collection('users').doc(number).set({
              "name": name,
              "phone": number,
              "status": "Unavalible",
              "uid": _auth.currentUser!.uid,
              "profile": data!["profile"]
            });
          } else {
            await _firestore.collection('users').doc(number).set({
              "name": name,
              "phone": number,
              "status": "Unavalible",
              "uid": _auth.currentUser!.uid,
              "profile": ""
            });
          }
        });

        Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      },
      verificationFailed: (FirebaseAuthException exception) {
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
                  keyboardType: TextInputType.number,
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () async {

                  print(_codeController.text.trim());

                  AuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: _codeController.text.trim(),
                  );
                  UserCredential userCredential= await _auth.signInWithCredential(credential);
                  userCredential.user!.updateDisplayName(name);

                  print("Login successfully");

                  await _firestore.collection('users').doc(number).get().then((snapshot) async {
                    if(snapshot.exists){
                      var data = snapshot.data();
                      await _firestore.collection('users').doc(number).set({
                        "name": name,
                        "phone": number,
                        "status": "Unavalible",
                        "uid": _auth.currentUser!.uid,
                        "profile": data!["profile"]
                      });
                    } else {
                      await _firestore.collection('users').doc(number).set({
                        "name": name,
                        "phone": number,
                        "status": "Unavalible",
                        "uid": _auth.currentUser!.uid,
                        "profile": ""
                      });
                    }
                  });

                  Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));

                },
                child: Text('Confirm'),
                textColor: Colors.white,
                color: Colors.blue,
              )
            ],
          );
        });
      },
      codeAutoRetrievalTimeout: (String verificationId){},
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