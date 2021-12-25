import 'package:chitchat/models/user.dart';
import 'package:chitchat/services/firebase_service.dart';

class GroupChat {
  late String guid;
  late LocalUser owner;
  late String message;
  late String msgType = "text";
  late String attatchmentURI;
  late DateTime time;

  final Service service = Service();

  GroupChat(String guid, LocalUser owner, String msgType, DateTime time, {String message = "", String attatchmentURI = ""}){
    this.guid = guid;
    this.owner = owner;
    this.msgType = msgType;
    this.message = message;
    this.attatchmentURI = attatchmentURI;
    this.time = time;
  }

  Future<Map<String, dynamic>> getDoc() async {

    time = DateTime.now();

    return {
      "guid": guid,
      "owner": owner.phone,
      "attatchmentURI": attatchmentURI,
      "message": message,
      "type": msgType,
      "time": time.microsecondsSinceEpoch
    };
  }
}