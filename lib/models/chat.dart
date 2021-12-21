import 'package:chitchat/models/user.dart';

class Chat {
  late LocalUser owner;
  late List<LocalUser> recievers;
  late String message;
  late DateTime time;

  Chat(LocalUser owner, List<LocalUser> recievers, String message, DateTime time){
    this.owner = owner;
    this.recievers = recievers;
    this.message = message;
    this.time = time;
  }

  // Chat cast()

}