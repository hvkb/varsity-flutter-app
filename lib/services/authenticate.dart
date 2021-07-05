import 'package:firebase_auth/firebase_auth.dart';

import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<User> get user {
    return _auth.authStateChanges();
  }

  String getCurrentUserID() {
    return _auth.currentUser.uid;
  }

  //register w email and password
  Future registerWithEmailAndPassword(
      String email, String password, String username, String reg_no) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user;
      await user.sendEmailVerification();
      await DatabaseService().createUserData(user.uid, username, email, reg_no);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } catch (e) {
      return null;
    }
  }

  bool checkEmailVerification() {
    return _auth.currentUser.emailVerified;
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
