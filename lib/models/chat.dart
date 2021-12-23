import 'package:chitchat/models/user.dart';
import 'package:chitchat/services/firebase_service.dart';

class Chat {
  late LocalUser owner;
  late LocalUser reciever;
  late String message;
  late String msgType = "text";
  late String attatchmentURI;
  late var attachment;
  late DateTime time;

  final Service service = Service();

  Chat(LocalUser owner, LocalUser reciever, String msgType, DateTime time, {String message = "", var attachment = null, String attatchmentURI = ""}){
    this.owner = owner;
    this.reciever = reciever;
    this.msgType == msgType;
    this.message = message;
    this.attatchmentURI = attatchmentURI;
    this.attachment = attachment;
    this.time = time;
  }

  Future<Map<String, dynamic>> getDoc() async {
    
    time = DateTime.now();

    if ( msgType != "text" ) {
      // store attatchment to firebase storage
      attatchmentURI = (await service.uploadFile(attachment))!;
    }
    return {
      "reciever": reciever.phone,
      "attatchmentURI": attatchmentURI,
      "message": message,
      "type": msgType,
      "time": time.microsecondsSinceEpoch,
      "seen": false
    };
  }



  // Chat cast()

}