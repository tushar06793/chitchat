import 'package:chitchat/models/user.dart';
import 'package:chitchat/services/firebase_service.dart';

class GroupChat {
  late String uid;
  late LocalUser owner;
  late List<LocalUser> recievers;
  late String message;
  late bool isAttachment;
  late var attachment;

  final Service service = Service();

  GroupChat(
      String uid, LocalUser owner, List<LocalUser> recievers, String message,
      {bool isAttachment = false, var attachment = null}) {
    this.uid = uid;
    this.owner = owner;
    this.recievers = recievers;
    this.message = message;
    this.isAttachment = isAttachment;
    this.attachment = attachment;
  }

  Future<Map<String, dynamic>> getDoc(DateTime time) async {
    if (isAttachment) {
      // store attatchment to firebase storage
      String URI = (await service.uploadFile(attachment))!;
      return {
        "uid": uid,
        "sendby": owner.phone,
        "attatchmentURI": URI,
        "type": "media",
        "time": time,
      };
    }
    return {
      "uid": uid,
      "sendby": owner.phone,
      "message": message,
      "type": "text",
      "time": time,
    };
  }

  // Chat cast()

}
