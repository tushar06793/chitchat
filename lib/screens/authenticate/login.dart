import 'package:chitchat/screens/home/home.dart';
import 'package:chitchat/services/auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final AuthService _auth = AuthService();

  String error = '';

  final usernameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final otpController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.lightGreenAccent,
                Colors.blue,
              ]),
            ),
          ),
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Container(
                height: 260,
                width: 300,
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formkey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        // Enter user name
                        TextFormField(
                          controller: usernameController,
                          decoration:
                              InputDecoration(labelText: 'Enter Your Name'),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value != null && (value.isEmpty)) {
                              return 'Invalid Format';
                            }
                            return null;
                          },
                          onSaved: (value) {},
                        ),

                        //Enter Mobile No.
                        TextFormField(
                          controller: phoneNumberController,
                          decoration: InputDecoration(labelText: 'Mobile No.'),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value != null &&
                                (value.isEmpty || value.length != 10)) {
                              return 'Invalid Format';
                            }
                            return null;
                          },
                        ),

                        SizedBox(
                          height: 30,
                        ),
                        RaisedButton(
                          child: Text('Login'),
                          onPressed: () async {

                            var username = usernameController.text;
                            var phoneNumber = phoneNumberController.text;

                            print(username);
                            print(phoneNumber);

                            AuthService.name = username;
                            await _auth.signInWithPhoneNumber(phoneNumber, context);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.blue,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          RaisedButton(
            child: Text('Sign in anom'),
            onPressed: () async {

              await _auth.signInAnom().then((user) {
                if (user != null) {
                  print("Login Sucessfull");
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomeScreen()));
                } else {
                  print("Login Failed");
                }
              });

            },
          ),
        ],
      ),
    );
  }
}