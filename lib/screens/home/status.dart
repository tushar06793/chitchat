import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
  final images;
  StatusScreen({this.images});

  get f => null;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: const EdgeInsets.only(top: 8.0)),
        ListTile(
          contentPadding: EdgeInsets.only(left: 10, right: 7),
          leading: CircleAvatar(
            backgroundImage: AssetImage(images),
          ),
          title: Text(
            "My status",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Tap To add status update"),
        ),
        Container(
          color: Colors.grey[300],
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Text('Recent Updates'),
            ],
          ),
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: ListTile(
            contentPadding: EdgeInsets.only(left: 5, right: 7),
            leading: Container(
              width: 70,
              height: 100,
              child: CircleAvatar(
                backgroundImage: AssetImage('user/devang.jpg'),
              ),
            ),
            title: Text("Devang More"),
            subtitle: Text("24 minutes ago"),
          ),
        ),
        Divider(),
        ListTile(
          contentPadding: EdgeInsets.only(left: 5, right: 7),
          leading: Container(
            width: 70,
            height: 100,
            child: CircleAvatar(
              backgroundImage: AssetImage('user/amit.jpg'),
            ),
          ),
          title: Text("Amit Gupta"),
          subtitle: Text("39 minutes ago"),
        ),
      ],
    );
  }
}
