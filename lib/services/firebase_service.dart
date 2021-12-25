import 'dart:io';
import 'package:chitchat/models/group.dart';
import 'package:uuid/uuid.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chitchat/models/user.dart';
import 'package:chitchat/models/chat.dart';
import 'package:chitchat/models/group_chat.dart';

class Service {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static String defaultProfile =
      "https://firebasestorage.googleapis.com/v0/b/droidrush2k21.appspot.com/o/files%2Fprofile_default.jpg?alt=media&token=0b581309-aafe-4640-9f15-263153257485";

  Future<bool> updateName(LocalUser user) async {
    await _firestore
        .collection('users')
        .doc(user.phone)
        .update({"name": user.username});
    return true;
  }

  Future<bool> updateProfile(LocalUser user) async {
    await _firestore
        .collection('users')
        .doc(user.phone)
        .update({"profile": user.profile});
    return true;
  }

  Future setStatus(LocalUser user, String status) async {
    await _firestore.collection('users').doc(user.phone).update({
      "status": status,
    });
  }

  Future<LocalUser?> searchUser(String phoneNumber) async {
    await _firestore.collection('users').doc(phoneNumber).get().then((SnapShot) async {
      var data = SnapShot.data();
      return LocalUser(
        data!['uid'], data['name'], phoneNumber, data["profile"], data["status"]);
    });
    return null;
  }

  Future<List<Map<String, dynamic>>?> fetchHistory(LocalUser user) async {
    List<Map<String, dynamic>> chats = [];

    // history of 1-1 chatting
    await _firestore
        .collection('users')
        .doc(user.phone)
        .collection("friends")
        .get()
        .then((SnapShot) async {
      for (var doc in SnapShot.docs) {
        var data = doc.data();
        LocalUser friend = (await searchUser(data["phone"]))!;
        chats.add({
          "isGroup": false,
          "friend": friend,
          "last_chat": data["last_sender"]
              ? Chat(user, friend, data["last_chat_type"],
                  DateTime.fromMicrosecondsSinceEpoch(data["last_chat_time"]),
                  message: data["last_chat_message"],
                  attatchmentURI: data["last_chat_URI"])
              : Chat(friend, user, data["last_chat_type"],
                  DateTime.fromMicrosecondsSinceEpoch(data["last_chat_time"]),
                  message: data["last_chat_message"],
                  attatchmentURI: data["last_chat_URI"])
        });
      }
    });

    // history of group chatting
    await _firestore
        .collection('users')
        .doc(user.phone)
        .collection("groups")
        .get()
        .then((SnapShot) async {
      for (var doc in SnapShot.docs) {
        var data = doc.data();
        Group group = (await searchGroup(data["guid"]))!;
        LocalUser owner = (await searchUser(data["phone"]))!;
        chats.add({
          "isGroup": true,
          "group": group,
          "last_chat": data["last_sender"]
              ? GroupChat(data["guid"], owner, data["last_chat_type"],
                  DateTime.fromMicrosecondsSinceEpoch(data["last_chat_time"]),
                  message: data["last_chat_message"],
                  attatchmentURI: data["last_chat_URI"])
              : GroupChat(data["guid"], owner, data["last_chat_type"],
                  DateTime.fromMicrosecondsSinceEpoch(data["last_chat_time"]),
                  message: data["last_chat_message"],
                  attatchmentURI: data["last_chat_URI"])
        });
      }
    });

    return chats;
  }

  Future<List<Chat>?> fetchChats(LocalUser user, LocalUser friend) async {
    List<Chat> chats = [];

    // chats of 1-1 chatting that owner sended
    await _firestore
        .collection('chatroom')
        .doc(user.phone)
        .collection("chats")
        .where("reciever", isEqualTo: friend.phone)
        .get()
        .then((SnapShot) async {
      for (var doc in SnapShot.docs) {
        var data = doc.data();
        chats.add(Chat(user, friend, data["type"],
            DateTime.fromMicrosecondsSinceEpoch(data["time"]),
            message: data["message"], attatchmentURI: data["attatchmentURI"]));
      }
    });

    // chats of 1-1 chatting that owner recieved
    await _firestore
        .collection('chatroom')
        .doc(friend.phone)
        .collection("chats")
        .where("reciever", isEqualTo: user.phone)
        .get()
        .then((SnapShot) async {
      for (var doc in SnapShot.docs) {
        var data = doc.data();
        chats.add(Chat(friend, user, data["type"],
            DateTime.fromMicrosecondsSinceEpoch(data["time"]),
            message: data["message"], attatchmentURI: data["attatchmentURI"]));
      }
    });

    return chats;
  }

  Future<bool> sendChat(Chat chat) async {
    Map<String, dynamic> doc = await chat.getDoc();

    // for owners
    await _firestore
        .collection('users')
        .doc(chat.owner.phone)
        .collection('friends')
        .doc(chat.reciever.phone)
        .set({
      "phone": chat.reciever.phone,
      "last_chat_type": chat.msgType,
      "last_chat_URI": chat.attatchmentURI,
      "last_chat_message": chat.message,
      "last_chat_time": chat.time.microsecondsSinceEpoch,
      "last_sender": true
    });

    // for reciever
    await _firestore
        .collection('users')
        .doc(chat.reciever.phone)
        .collection('friends')
        .doc(chat.owner.phone)
        .set({
      "phone": chat.owner.phone,
      "last_chat_type": chat.msgType,
      "last_chat_URI": chat.attatchmentURI,
      "last_chat_message": chat.message,
      "last_chat_time": chat.time.microsecondsSinceEpoch,
      "last_sender": false
    });

    await _firestore
        .collection("chatroom")
        .doc(chat.owner.phone)
        .collection("chats")
        .add(doc);

    return true;
  }

  // Groups


  Future<Group> createGroup(String name, LocalUser admin, List<LocalUser> members) async {

    List<String> membersPhone = [];
    for(LocalUser member in members){
      membersPhone.add(member.phone);
    }

    String guid = Uuid().v1();
    await _firestore.collection("groups").doc(guid).set({
      "guid": guid,
      "name": name,
      "profile": defaultProfile,
      "admin": admin.phone,
      "members": membersPhone
    });
    return new Group(guid, name, admin, members, defaultProfile);
  }

  Future<Group?> searchGroup(String guid) async {
    await _firestore.collection("groups").doc(guid).get().then((SnapShot) async {
      var data = SnapShot.data();
      LocalUser owner = (await searchUser(data!["owner"]))!;
      List<LocalUser> members = [];
      for(String membersPhone in data["members"]){
        LocalUser member = (await searchUser(membersPhone))!;
        members.add(member);
      }
      return Group(
        guid, data["name"], owner, members, data["profile"]
      );
    });
    return null;
  }

  Future<bool> addMember(String memberPhone, Group group) async {
    await _firestore.collection("groups").doc(group.guid).get().then((SnapShot) async {
      var data = SnapShot.data();
      List<String> membersPhone = data!["members"];
      membersPhone.add(memberPhone);
      await _firestore.collection("gtoups").doc(group.guid).set({
        "members": membersPhone
      });
    });
    return true;
  }

  Future<bool> removeMembers(String memberPhone, Group group) async {
    await _firestore.collection("groups").doc(group.guid).get().then((SnapShot) async {
      var data = SnapShot.data();
      List<String> membersPhone = data!["members"];
      membersPhone.remove(memberPhone);
      await _firestore.collection("gtoups").doc(group.guid).set({
        "members": membersPhone
      });
    });
    return true;
  }

  Future<List<GroupChat>> fetchGroupChat(Group group) async {

    List<GroupChat> gchats = [];

    await _firestore.collection("groupchats").where("guid", isEqualTo: group.guid).get().then((SnapShot) async {
      for (var doc in SnapShot.docs) {
        var data = doc.data();
        LocalUser owner = (await searchUser(data["owner"]))!;
        gchats.add(GroupChat(group.guid, owner, data["type"],
            DateTime.fromMicrosecondsSinceEpoch(data["time"]),
            message: data["message"], attatchmentURI: data["attatchmentURI"]));
      }
    });
    return [];
  }

  Future<bool> sendGroupChat(Group group, GroupChat chat) async {
    Map<String, dynamic> doc = await chat.getDoc();

    await _firestore.collection("users").doc(chat.owner.phone).collection("groups").doc(group.guid).set({
      "guid": group.guid,
      "last_sender": true,
      "phone": chat.owner.phone,
      "last_chat_type": chat.msgType,
      "last_chat_URI": chat.attatchmentURI,
      "last_chat_message": chat.message,
      "last_chat_time": chat.time.microsecondsSinceEpoch,
    });

    if(chat.owner.phone != group.admin.phone){
      await _firestore.collection("users").doc(chat.owner.phone).collection("groups").doc(group.guid).set({
        "guid": group.guid,
        "last_sender": false,
        "phone": chat.owner.phone,
        "last_chat_type": chat.msgType,
        "last_chat_URI": chat.attatchmentURI,
        "last_chat_message": chat.message,
        "last_chat_time": chat.time.microsecondsSinceEpoch,
      });
    }

    for(LocalUser member in group.members){
      if(member.phone == chat.owner.phone){
        continue;
      }
      await _firestore.collection("users").doc(member.phone).collection("groups").doc(group.guid).set({
        "guid": group.guid,
        "last_sender": false,
        "phone": chat.owner.phone,
        "last_chat_type": chat.msgType,
        "last_chat_URI": chat.attatchmentURI,
        "last_chat_message": chat.message,
        "last_chat_time": chat.time.microsecondsSinceEpoch,
      });
    }

    await _firestore.collection("groupchats").add(doc);

    return true;
  }

  Future<String?> uploadFile(File file) async {
    // save it on firebase storage
    String fileName = Uuid().v1();
    String extension = file.path.split(".").last;
    var ref = _storage.ref().child('files').child("$fileName.$extension");
    var uploadTask = await ref.putFile(file).catchError((error) async {
      return null;
    });
    return await uploadTask.ref.getDownloadURL();
  }
}
