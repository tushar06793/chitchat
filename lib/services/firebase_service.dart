import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chitchat/models/user.dart';
import 'package:chitchat/models/chat.dart';
import 'package:chitchat/models/group_chat.dart';

class Service {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<bool> updateName(LocalUser user) async {
    await _firestore.collection('users').doc(user.phone).update({ "name": user.username });
    return true;
  }

  Future<bool> updateProfile(LocalUser user) async {
    await _firestore.collection('users').doc(user.phone).update({ "profile": user.profile });
    return true;
  }

  Future<List<Map<String, dynamic>>?> fetchHistory(LocalUser user) async {
    List<Map<String, dynamic>> chats = [];
    
    // history of 1-1 chatting
    await _firestore.collection('users').doc(user.phone).collection("friends").get().then((SnapShot) async {
      for(var doc in SnapShot.docs){
        var data = doc.data();
        LocalUser friend = await searchUser(data["phone"]);
        chats.add({
          "friend": friend,
          "last_chat": doc.data()["last_sender"] 
            ? new Chat(user, friend, data["last_chat_type"], DateTime.fromMicrosecondsSinceEpoch(data["last_chat_time"]), message: data["last_chat"], attatchmentURI: data["last_chat_URI"]) 
            : new Chat(friend, user, data["last_chat_type"], DateTime.fromMicrosecondsSinceEpoch(data["last_chat_time"]), message: data["last_chat"], attatchmentURI: data["last_chat_URI"]) 
        });
      }
    });

    return chats;
  }

  Future<List<Chat>?> fetchChats(LocalUser user, LocalUser friend) async {
    List<Chat> chats = [];
    
    // chats of 1-1 chatting that owner sended
    await _firestore.collection('chatroom').doc(user.phone).collection("chats").where("reciever", isEqualTo: friend.phone).get().then((SnapShot) async {
      for(var doc in SnapShot.docs){
        var data = doc.data();
        chats.add(Chat(user, friend, data["type"], DateTime.fromMicrosecondsSinceEpoch(data["time"]), message: data["message"], attatchmentURI: data["attatchmentURI"]));
      }
    });

    // chats of 1-1 chatting that owner recieved
    await _firestore.collection('chatroom').doc(friend.phone).collection("chats").where("reciever", isEqualTo: user.phone).get().then((SnapShot) async {
      for(var doc in SnapShot.docs){
        var data = doc.data();
        chats.add(Chat(friend, user, data["type"], DateTime.fromMicrosecondsSinceEpoch(data["time"]), message: data["message"], attatchmentURI: data["attatchmentURI"]));
      }
    });

    return chats;
  }

  Future setStatus(LocalUser user, String status) async {
    await _firestore.collection('users').doc(user.phone).update({
      "status": status,
    });
  }

  Future<LocalUser> searchUser(String phoneNumber) async {
    var value = await _firestore.collection('users').where("phone", isEqualTo: phoneNumber).get();
    var doc = value.docs[0].data();
    return LocalUser(doc['uid'], doc['name'], phoneNumber, doc["profile"]);
  }

  Future<bool> sendChat(Chat chat) async {
    Map<String, dynamic> doc = await chat.getDoc();

    // for owners
    await _firestore.collection('users').doc(chat.owner.phone).collection('friends').doc(chat.reciever.phone).set({
      "phone": chat.reciever.phone,
      "last_chat_type": chat.msgType,
      "last_chat_URI": chat.attatchmentURI,
      "last_chat_message": chat.message,
      "last_chat_time": chat.time.microsecondsSinceEpoch,
      "last_sender": true
    });

    // for reciever
    await _firestore.collection('users').doc(chat.reciever.phone).collection('friends').doc(chat.owner.phone).set({
      "phone": chat.owner.phone,
      "last_chat_type": chat.msgType,
      "last_chat_URI": chat.attatchmentURI,
      "last_chat_message": chat.message,
      "last_chat_time": chat.time.microsecondsSinceEpoch,
      "last_sender": false
    });

    await _firestore.collection("chatroom").doc(chat.owner.phone).collection("chats").add(doc);

    return true;
  }

  Future<bool> sendGroupChat(GroupChat chat) async {
    Map<String, dynamic> doc = await chat.getDoc(new DateTime.now());
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