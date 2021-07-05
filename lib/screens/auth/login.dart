import 'package:flutter/material.dart';
import 'package:swemaybe/services/authenticate.dart';
import 'package:swemaybe/view/scale.dart';

class Login extends StatefulWidget {
  Function toggleView;
  Login({this.toggleView});
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String error = "";

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
            child: Center(
                child: CircularProgressIndicator(
              backgroundColor: Color(0xff16344E),
            )),
            color: Colors.white,
          )
        : Scaffold(
            appBar: AppBar(actions: [
              TextButton(
                  onPressed: null,
                  child: Text('varsity.',
                      style: TextStyle(color: Colors.white, fontSize: 20)))
            ]),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.safeBlockVertical * 5,
                      horizontal: SizeConfig.safeBlockVertical * 4),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 3,
                        ),
                        Text(
                          'LOGIN',
                          style: TextStyle(
                              letterSpacing: 10,
                              fontSize: SizeConfig.safeBlockHorizontal * 5),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 3,
                        ),
                        TextFormField(
                          //  style: TextStyle(fontSize: 17),

                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            // border: Border,
                            hintText: 'Email',
                            alignLabelWithHint: true,
                          ),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          validator: (val) =>
                              val.isEmpty ? 'Enter email' : null,
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 3,
                        ),
                        TextFormField(
                          obscureText: true,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          validator: (val) =>
                              val.isEmpty ? 'Enter password' : null,
                          //style: TextStyle(fontSize: 17),
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            alignLabelWithHint: true,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 5,
                        ),
                        RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result = await _auth
                                  .signInWithEmailAndPassword(email, password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error = 'invalid credentials';
                                });
                              }
                            }
                          },
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.safeBlockVertical * 2,
                              horizontal: SizeConfig.safeBlockVertical * 3),
                          child: Text(
                            "Sign In",
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 3,
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red[600]),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 3,
                        ),
                        TextButton(
                          onPressed: () {
                            widget.toggleView();
                          },
                          child: Text(
                            'Register?',
                            style: TextStyle(color: Color(0xff16344E)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
