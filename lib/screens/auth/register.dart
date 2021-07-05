import 'package:flutter/material.dart';
import 'package:swemaybe/view/scale.dart';
import '../../services/authenticate.dart';

class Register extends StatefulWidget {
  Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String password = "";
  String reg_no = "";
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
                          'REGISTER',
                          style: TextStyle(
                              letterSpacing: 10,
                              fontSize: SizeConfig.safeBlockHorizontal * 5),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 3,
                        ),
                        TextFormField(
                          // style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            // prefixIcon: AppStyles.iconStyling(Icons.person_outline_sharp, AppColors.Yellow),
                            hintText: 'Username',
                            alignLabelWithHint: true,
                          ),
                          onChanged: (val) {
                            setState(() {
                              name = val;
                            });
                          },
                          validator: (val) =>
                              val.isEmpty ? 'Enter username' : null,
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
                          style: TextStyle(fontSize: 17),
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            alignLabelWithHint: true,
                            fillColor: Colors.green,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 3,
                        ),
                        TextFormField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            hintText: 'Registration No',
                            alignLabelWithHint: true,
                          ),
                          validator: (val) => val.isEmpty
                              ? 'Enter your registration number'
                              : null,
                          onChanged: (val) {
                            setState(() {
                              reg_no = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: SizeConfig.safeBlockVertical * 3,
                        ),
                        Container(
                          child: RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result =
                                    await _auth.registerWithEmailAndPassword(
                                        email, password, name, reg_no);
                                if (result == null) {
                                  setState(() {
                                    loading = false;
                                    error = 'invalid details';
                                  });
                                }
                              }
                            },
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.safeBlockVertical * 2,
                                horizontal: SizeConfig.safeBlockVertical * 3),
                            child: Text(
                              "Sign Up",
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.safeBlockVertical * 3),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        ),
                        TextButton(
                          onPressed: () {
                            widget.toggleView();
                          },
                          child: Text(
                            'Sign In?',
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
// dynamic result = await _auth.registerWithEmailAndPassword(email, password, name, reg_no);
