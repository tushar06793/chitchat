import 'package:chitchat/models/chat.dart';
import 'package:chitchat/models/user.dart';
import 'package:chitchat/screens/home/Conversation.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  Chat? lastChat;
  final LocalUser owner, friend;
  ChatScreen({this.lastChat, required this.owner, required this.friend});

  Text setTime() {
    if (lastChat != null) {
      int diffDays = DateTime.now().difference(lastChat!.time).inDays;
      String timeText = "";
      print(diffDays);
      if (diffDays == 0) {
        timeText = lastChat!.time.hour.toString() +
            ":" +
            lastChat!.time.minute.toString();
      } else if (diffDays == 1) {
        timeText = "Yesterday";
      } else {
        timeText = lastChat!.time.day.toString() +
            "/" +
            lastChat!.time.month.toString() +
            "/" +
            lastChat!.time.year.toString();
      }
      return Text(timeText);
    }
    return Text("");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: const EdgeInsets.only(top: 8.0)),
        ListTile(
          contentPadding: EdgeInsets.only(left: 5, right: 7),
          leading: GestureDetector(
            child: CircleAvatar(
              backgroundImage:
                  friend.profile != "" ? AssetImage(friend.profile) : null,
            ),
            onTap: () {
              print("amit");
            },
          ),
          title: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      ConversationScreen(owner: owner, friend: friend),
                ),
              );
            },
            child: Container(
              child: Text(friend.username),
            ),
          ),
          subtitle: lastChat != null ? Text(lastChat!.message) : null,
          trailing: Column(
            children: [
              setTime(),
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
