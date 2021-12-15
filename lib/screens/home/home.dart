import 'package:chitchat/models/user.dart';
import 'package:chitchat/screens/home/chats.dart';
import 'package:chitchat/screens/home/status.dart';
import 'package:chitchat/screens/home/calls.dart';
import 'package:chitchat/services/auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  final User user;
  HomeScreen({ required this.user });

  @override
  _HomeScreenState createState() => _HomeScreenState(user: user);
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  final AuthService _auth = AuthService();

  final User user;
  _HomeScreenState({ required this.user });

  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 4, initialIndex: 1, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ChitChat'),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            IconButton(
              onPressed: () {
                _auth.signOut();
              }, 
              icon: Icon(Icons.more_vert)
            )
          ],
          bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorPadding: EdgeInsets.all(10),
            labelPadding: EdgeInsets.all(12),
            tabs: [
              Icon(Icons.camera_alt),
              Container(
                width: 70,
                alignment: Alignment.center,
                child: Text('CHATS'),
              ),
              Container(
                width: 70,
                alignment: Alignment.center,
                child: Text('STATUS'),
              ),
              Container(
                width: 70,
                alignment: Alignment.center,
                child: Text('CALLS'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Text('chats'),
            //Chats page
            ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ChatScreen(
                        images: 'user/devang.jpg',
                        title: 'Devang More',
                        msg: 'Aur Bhai???',
                      ),
                      ChatScreen(
                        images: 'user/amit.jpg',
                        title: 'Amit Gupta',
                        msg: 'Bna Kya??',
                      ),
                      ChatScreen(
                        images: 'user/chicken dinner.jpg',
                        title: 'CHicken DInner',
                        msg: 'Devang More : Arpit ko Dengue ho gya hai',
                      ),
                    ],
                  );
                }),
            //Status page
            ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      StatusScreen(
                        images: 'user/tushar.jpg',
                      ),
                    ],
                  );
                }),
            //Calls page
            ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      CallsScreen(
                        images: 'user/devang.jpg',
                        title: 'Devang More',
                      ),
                      CallsScreen(
                        images: 'user/amit.jpg',
                        title: 'Amit Gupta',
                      ),
                    ],
                  );
                }),
          ],
        ),
        floatingActionButton: _tabController.index == 1
            ? FloatingActionButton(
                onPressed: () {},
                backgroundColor: Theme.of(context).primaryColorLight,
                child: Icon(Icons.message),
              )
            : FloatingActionButton(
                onPressed: () {},
                backgroundColor: Theme.of(context).primaryColorLight,
                child: Icon(Icons.camera_alt),
              ));
  }
}
