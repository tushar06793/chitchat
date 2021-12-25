import 'package:chitchat/models/user.dart';

class Group {
  late String guid;
  late String gname;
  late LocalUser admin;
  late List<LocalUser> members;
  late String gprofile;

  Group(String guid, String gname, LocalUser admin, List<LocalUser> members, String profile){
    this.guid = guid;
    this.gname = gname;
    this.admin = admin;
    this.members = members;
    this.gprofile = profile;
  }

}