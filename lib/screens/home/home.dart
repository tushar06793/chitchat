import 'dart:async';

import 'package:chitchat/models/chat.dart';
import 'package:chitchat/models/user.dart';
import 'package:chitchat/screens/authenticate/login.dart';
import 'package:chitchat/screens/home/chats.dart';
import 'package:chitchat/screens/home/status.dart';
import 'package:chitchat/screens/home/calls.dart';
import 'package:chitchat/services/auth.dart';
import 'package:chitchat/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  final Service service = Service();

  late LocalUser user;
  late TabController _tabController;
  List<Map<String, dynamic>> chatHistory = [];
  final TextEditingController _search = TextEditingController();
  Timer? timer;

  void fetchHistory() async {
    List<Map<String, dynamic>> updatedHistory =
        (await service.fetchHistory(user))!;
    print(updatedHistory);
    setState(() {
      chatHistory = updatedHistory;
    });
  }

  @override
  void initState() {
    _tabController = new TabController(length: 4, initialIndex: 1, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
    user = _auth.castLocalUser(_auth.getUser()!)!;
    _auth.fetchProfile(user);
    service.setStatus(user, "Online");
    fetchHistory();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => fetchHistory());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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

  Future getImage() async {
    XFile dp;
    ImagePicker _picker = ImagePicker();

    dp = (await _picker.pickImage(source: ImageSource.gallery))!;
    print(dp.path);
    // setState(() {
    //   user.image = dp;
    // });
  }

  Future getImageThroughCam() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    // chatHistory = (await service.fetchHistory(user))!;
    // print(chatHistory);

    if (user == null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('ChitChat'),
          actions: [
            IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
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
                        ),
                        FlatButton(
                          onPressed: () async {
                            String searchNumber = _search.text.trim();
                            if (!searchNumber.startsWith("+91")) {
                              searchNumber = "+91" + searchNumber;
                            }
                            LocalUser searchUser =
                                await service.searchUser(searchNumber);

                            Navigator.pop(context);

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return AlertDialog(
                                  title: ChatScreen(
                                    friend: searchUser,
                                    owner: user,
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
                              }
                            );
                          },
                          child: Text('Search'),
                          textColor: Colors.white,
                          color: Colors.blue,
                        )
                      ],
                    );
                  }
                );
              },
              icon: Icon(Icons.search)
            ),
            PopupMenuButton<String>(
              itemBuilder: (BuildContext Context) {
                return [
                  PopupMenuItem(
                    child: Text("Create Group"),
                    value: "Create Group",
                  ),
                  PopupMenuItem(
                    child: Text("Settings"),
                    value: "Settings",
                  ),
                  PopupMenuItem(
                    child: Text("Log out"),
                    value: "Log out"
                  ),
                ];
            })
          ],
          bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorPadding: EdgeInsets.all(10),
            labelPadding: EdgeInsets.all(12),
            tabs: [
              IconButton(
                  onPressed: () => getImageThroughCam(),
                  icon: Icon(Icons.camera_alt)),
              Container(
                width: 70,
                alignment: Alignment.center,
                child: Text("CHATS"),
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
                itemCount: chatHistory.length,
                itemBuilder: (context, index) {
                  LocalUser friend = chatHistory[index]["friend"];
                  Chat lastChat = chatHistory[index]["last_chat"];

                  return Column(
                    children: [
                      ChatScreen(
                        friend: friend,
                        owner: user,
                        lastChat: lastChat,
                      )
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
