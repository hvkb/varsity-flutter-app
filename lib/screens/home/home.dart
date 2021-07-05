import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swemaybe/screens/home/calendar/calendar.dart';
import 'package:swemaybe/screens/home/creator/view_posts.dart';
import 'package:swemaybe/services/authenticate.dart';
import 'events/join_event.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _appbarTitle = 'Home';
  int _currentIndex = 0;
  bool _switchValue = true;
  final widgetList = [ViewPosts(), Calendar(), JoinEvent()];

  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          _appbarTitle,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _auth.signOut();
            },
            child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: widgetList.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.photo_camera_outlined),
              title: Text(
                "",
                style: TextStyle(fontSize: 0),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_sharp),
              title: Text(" ", style: TextStyle(fontSize: 0))),
          BottomNavigationBarItem(
              icon: Icon(Icons.create_new_folder_outlined),
              title: Text("", style: TextStyle(fontSize: 0))),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 0) {
              _appbarTitle = 'feed';
            } else if (index == 1) {
              _appbarTitle = 'calendar';
            } else if (index == 2) {
              _appbarTitle = 'events';
            }
          });
        },
      ),
    );
  }
}
