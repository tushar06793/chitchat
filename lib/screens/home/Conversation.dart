import 'package:flutter/material.dart';

class ConversationScreen extends StatelessWidget {
  final images;
  final title;
  ConversationScreen({this.images, this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: AssetImage(images),
        ),
        title: Text(title),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        child: TextFormField(
          decoration: InputDecoration(
            prefix: IconButton(
              onPressed: () {},
              icon: Icon(),
            ),
            suffix: IconButton(
              onPressed: () {},
              icon: Icon(Icons.attach_file),
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
