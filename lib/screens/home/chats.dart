import 'package:chitchat/screens/home/Conversation.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final images;
  final title;
  final msg;
  ChatScreen({this.images, this.title, this.msg});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: const EdgeInsets.only(top: 8.0)),
        ListTile(
          contentPadding: EdgeInsets.only(left: 5, right: 7),
          leading: CircleAvatar(
            backgroundImage: AssetImage(images),
          ),
          title: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ConversationScreen(
                        images: images.toString(), title: title.toString())),
              );
            },
            child: Container(
              child: Text(title),
            ),
          ),
          subtitle: Text(msg),
          trailing: Column(
            children: [
              Text('11:59'),
              Container(
                width: 24,
                height: 32,
                child: Expanded(
                    flex: 3,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      child: Text(
                        '3',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              )
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
