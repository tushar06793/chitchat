import 'dart:async';

import 'package:chitchat/models/chat.dart';
import 'package:chitchat/models/user.dart';
import 'package:chitchat/services/firebase_service.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {

  LocalUser owner, friend;

  ConversationScreen({required this.owner, required this.friend});

  @override
  _ConversationScreenState createState() => _ConversationScreenState(owner: owner, friend: friend);
}

class _ConversationScreenState extends State<ConversationScreen> {

  Service service = Service();
  LocalUser owner, friend;

  List<Chat>? sendedChats, recieveChats = [];
  final TextEditingController _message = TextEditingController();
  Timer? timer;

  _ConversationScreenState({required this.owner, required this.friend});

  void fetchNewChats() async {
    List<List<Chat>> updatedChats = (await service.fetchChats(owner, friend))!;
    print(updatedChats);
    setState(() {
      sendedChats = updatedChats[0];
      recieveChats = updatedChats[1];
    });
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => fetchNewChats());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: friend.image != "" ? AssetImage(friend.image) : null,
        ),
        title: Text(friend.username),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: TextFormField(
          controller: _message,
          decoration: InputDecoration(
            suffix: IconButton(
              onPressed: () async {
                String mesaage = _message.text.trim();
                if(mesaage != ""){
                  Chat chat = new Chat(owner, friend, "text", DateTime.now(), message: mesaage);
                  await service.sendChat(chat);
                  _message.clear();
                }
              },
              icon: Icon(Icons.send),
            ),
            labelText: 'Message',
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(Icons.camera_alt),
            ),
            icon: IconButton(
              onPressed: () {},
              icon: Icon(Icons.mic),
            ),
          ),
        ),
      ),
    );
  }
}
