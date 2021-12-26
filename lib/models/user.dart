import 'dart:io';
import 'package:chitchat/services/firebase_service.dart';

class LocalUser {
  late String uid;
  late String username;
  late String phone;
  late String profile;

  LocalUser(
      String uid, String username, String phone, String profile, String st) {
    this.uid = uid;
    this.username = username;
    this.phone = phone;
    this.profile = profile;
  }

  Future<bool> updateName(String username) async {
    this.username = username;
    return await Service().updateName(this);
  }

  Future<bool> updateProfile(File file) async {
    this.profile = (await Service().uploadFile(file))!;
    return await Service().updateProfile(this);
  }
}
