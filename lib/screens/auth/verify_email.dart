import 'package:flutter/material.dart';
import 'package:swemaybe/services/authenticate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:swemaybe/view/scale.dart';

class VerifyEmail extends StatelessWidget {
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('email verification'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.safeBlockVertical * 5,
            horizontal: SizeConfig.safeBlockVertical * 4),
        child: Column(
          children: [
            Text(
              'Welcome to varsity! \n\nIt seems like your email address hasn’t been verified yet. To proceed further, please click on the verification link we sent to your email',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            RaisedButton(
              onPressed: () async {
                await _auth.signOut();
                Fluttertoast.showToast(
                    msg: "Please sign in to continue",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Color(0xff16344E),
                    textColor: Colors.white);
              },
              child: Text('I verified'),
            ),
          ],
        ),
      ),
    );
  }
}
