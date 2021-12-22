import 'package:chitchat/models/chat.dart';
import 'package:chitchat/models/user.dart';
import 'package:chitchat/screens/authenticate/login.dart';
import 'package:chitchat/screens/home/chats.dart';
import 'package:chitchat/screens/home/status.dart';
import 'package:chitchat/screens/home/calls.dart';
import 'package:chitchat/services/auth.dart';
import 'package:chitchat/services/firebase_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  final AuthService _auth = AuthService();
  final Service service = Service();
  
  late LocalUser user;
  late TabController _tabController;
  late List<Map<String, dynamic>> chatHistory;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    _tabController = new TabController(length: 4, initialIndex: 1, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
    user = _auth.castLocalUser(_auth.getUser()!)!;
    service.setStatus(user, "Online");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      service.setStatus(user, "Online");
    } else {
      // offline
      service.setStatus(user, "Offline");
    }
  }

  @override
  Widget build(BuildContext context) {

    // chatHistory = (await service.fetchHistory(user))!;
    // print(chatHistory);

    if(user == null){
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('ChitChat'),
          actions: [
            IconButton(
              onPressed: () async {
                showDialog(context: context, barrierDismissible: false, builder: (context) {
                  return AlertDialog(
                    title: Text('Search User'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _search,
                          keyboardType: TextInputType.number,
                        )
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text('Back'),
                        textColor: Colors.white,
                        color: Colors.blue,
                      ), FlatButton(
                        onPressed: () async {
                          String searchNumber = _search.text.trim();
                          if(!searchNumber.startsWith("+91")){
                            searchNumber = "+91" + searchNumber;
                          }
                          LocalUser searchUser = await service.searchUser(searchNumber);

                          String searchUserName = searchUser.username;
                          String searchUserPhone = searchUser.phone;

                          Navigator.pop(context);

                          showDialog(context: context, barrierDismissible: false, builder: (context) {
                            return AlertDialog(
                              title: ChatScreen(
                                images: 'user/tushar.jpg',
                                title: '$searchUserName',
                                msg: 'Aur Bhai???',
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Back'),
                                  textColor: Colors.white,
                                  color: Colors.blue,
                                )
                              ],
                            );
                          });
                        },
                        child: Text('Search'),
                        textColor: Colors.white,
                        color: Colors.blue,
                      )
                    ],
                  );
                });
              }, 
              icon: Icon(Icons.search)
            ),
            IconButton(
              onPressed: () async {
                // open a builder
                showDialog(context: context, barrierDismissible: false, builder: (context) {
                  return AlertDialog(
                    title: Text('Are you sure you want to Sign Out'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                    ),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text('No'),
                        textColor: Colors.white,
                        color: Colors.blue,
                      ),
                      FlatButton(
                        onPressed: () async {
                          await _auth.signOut();
                          Navigator.push(
                                context, MaterialPageRoute(builder: (_) => LoginScreen()));
                        },
                        child: Text('Yes Sign out'),
                        textColor: Colors.white,
                        color: Colors.red
                      )
                    ],
                  );
                });
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
