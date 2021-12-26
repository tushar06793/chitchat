import 'package:chitchat/models/user.dart';

class Group {
  late String uid;
  late String gname;
  late List<LocalUser> members;
  late String gprofile;

  Group(String uid, String gname, List<LocalUser> members, {String? profile}){
    this.uid = uid;
    this.gname = gname;
    this.members = members;
    this.gprofile = profile != null ? profile : "";
  }

}