import 'package:chitchat/models/user.dart';
import 'package:chitchat/services/firebase_service.dart';

class Chat {
  late String uid;
  late LocalUser owner;
  late LocalUser reciever;
  late String message;
  late bool isAttachment;
  late var attachment;

  final Service service = Service();

  Chat(String uid, LocalUser owner, LocalUser reciever, String message, {bool isAttachment = false, var attachment = null}){
    this.uid = uid;
    this.owner = owner;
    this.reciever = reciever;
    this.message = message;
    this.isAttachment = isAttachment;
    this.attachment = attachment;
  }

  Future<Map<String, dynamic>> getDoc() async {
    if ( isAttachment ) {
      // store attatchment to firebase storage
      String URI = await service.storeAttachment(attachment);
      return {
        "uid": uid,
        "attatchmentURI": URI,
        "type": "media",
        "time": new DateTime.now(),
        "seen": false,
        "sender": true
      };
    }
    return {
      "uid": uid,
      "message": message,
      "type": "text",
      "time": new DateTime.now(),
      "seen": false,
      "sender": true
    };
  }



  // Chat cast()

}