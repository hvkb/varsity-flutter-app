import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swemaybe/screens/auth/auth_wrapper.dart';
import 'package:swemaybe/screens/auth/verify_email.dart';
import 'package:swemaybe/screens/home/home.dart';
import 'package:swemaybe/services/authenticate.dart';
import 'package:swemaybe/services/database.dart';

class LandingPage extends StatelessWidget {
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DatabaseService _db = DatabaseService();
    if (user != null) {
      return _auth.checkEmailVerification() ? Home() : VerifyEmail();
      // return Home();
    } else {
      return AuthWrapper();
    }
  }
}
