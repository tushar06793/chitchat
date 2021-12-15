import 'package:chitchat/chats.dart';
import 'package:chitchat/status.dart';
import 'package:flutter/material.dart';
import 'package:chitchat/calls.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
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
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
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
                width: 50,
                alignment: Alignment.center,
                child: Text('CHATS'),
              ),
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text('STATUS'),
              ),
              Container(
                width: 50,
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