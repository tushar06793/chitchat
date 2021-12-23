import 'package:chitchat/services/firebase_service.dart';

class LocalUser {
  late String uid;
  late String username;
  late String phone;
  String profile = "";

  LocalUser(String uid, String username, String phone){
    this.uid = uid;
    this.username = username;
    this.phone = phone;
  }

  Future<bool> updateUser(String username, String profile) async {
    this.profile = profile;
    this.username = username;
    return await Service().updateUser(this);
  }
}