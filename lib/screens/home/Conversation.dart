import 'dart:async';
import 'dart:io';
import 'package:chitchat/models/chat.dart';
import 'package:chitchat/models/user.dart';
import 'package:chitchat/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ConversationScreen extends StatefulWidget {
  LocalUser owner, friend;

  ConversationScreen({required this.owner, required this.friend});

  @override
  _ConversationScreenState createState() =>
      _ConversationScreenState(owner: owner, friend: friend);
}

class _ConversationScreenState extends State<ConversationScreen> {
  Service service = Service();
  LocalUser owner, friend;

  List<Chat>? chats = [];
  final TextEditingController _message = TextEditingController();
  Timer? timer;
  late File imageFile;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  _ConversationScreenState({required this.owner, required this.friend});

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) async {
      if (xFile != null) {
        imageFile = File(xFile.path);
        String URI = (await service.uploadFile(imageFile))!;
        service.sendChat(new Chat(owner, friend, "img", new DateTime.now(),
            attatchmentURI: URI));
      }
    });
  }

  void fetchNewChats() async {
    List<Chat> updatedChats = (await service.fetchChats(owner, friend))!;
    updatedChats.sort((Chat a, Chat b) =>
        a.time.microsecondsSinceEpoch.compareTo(b.time.microsecondsSinceEpoch));
    print(updatedChats);
    setState(() {
      chats = updatedChats;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchNewChats();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => fetchNewChats());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Chat chat = new Chat(owner, friend, "text", DateTime.now(),
          message: _message.text.trim());
      _message.clear();
      await service.sendChat(chat);
      fetchNewChats();
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage:
              friend.profile != "" ? AssetImage(friend.profile) : null,
        ),
        title: Text(friend.username),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(owner.phone)
                    .collection('chats')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: chats!.length,
                      itemBuilder: (context, index) {
                        return messages(
                            size, chats![index], owner, friend, context);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () => getImage(),
                              icon: Icon(Icons.photo),
                            ),
                            hintText: "Send Message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.send), onPressed: onSendMessage),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Chat chat, LocalUser owner, LocalUser friend,
      BuildContext context) {
    return chat.msgType == "text"
        ? Container(
            width: size.width,
            alignment: chat.owner == owner
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
              ),
              child: Text(
                chat.message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container(
            height: size.height / 2.5,
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: chat.owner == owner
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShowImage(
                    imageUrl: chat.attatchmentURI,
                  ),
                ),
              ),
              child: Container(
                height: size.height / 2.5,
                width: size.width / 2,
                decoration: BoxDecoration(border: Border.all()),
                alignment: chat.attatchmentURI != "" ? null : Alignment.center,
                child: chat.attatchmentURI != ""
                    ? Image.network(
                        chat.attatchmentURI,
                        fit: BoxFit.cover,
                      )
                    : CircularProgressIndicator(),
              ),
            ),
          );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
