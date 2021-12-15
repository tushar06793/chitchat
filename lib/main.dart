import 'package:chitchat/screens/wrapper.dart';
import 'package:chitchat/services/auth.dart';
import 'package:chitchat/models/user.dart';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>(create: (_) => AuthService().user),
      ],
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
