import 'package:flutter/material.dart';
import 'package:swemaybe/screens/auth/register.dart';
import 'package:swemaybe/screens/auth/login.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn
        ? Login(toggleView: toggleView)
        : Register(toggleView: toggleView);
  }
}
