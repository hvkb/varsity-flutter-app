import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:swemaybe/screens/auth/login.dart';
import 'package:swemaybe/screens/auth/register.dart';
import 'package:swemaybe/screens/auth/verify_email.dart';
import 'package:swemaybe/screens/landing_page.dart';
import 'package:swemaybe/view/scale.dart';

import 'services/authenticate.dart';
import 'package:provider/provider.dart';

void main() async {
  //initialise firebase app
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.all(12),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Color(0xff16344E)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(color: Colors.grey[300]),
            ),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Color(0xff16344E), //  <-- dark color
            textTheme: ButtonTextTheme
                .primary, //  <-- this auto selects the right color
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              unselectedIconTheme: IconThemeData(
                color: Color(0xff16344E),
              ),
              selectedIconTheme: IconThemeData(
                color: Color(0xff16344E),
              )),
          primaryColor: Color(0xff16344E),
          accentColor: Color(0xff16344E),
          colorScheme: ColorScheme.light(primary: const Color(0xff16344E)),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Color(0xff16344E),
              foregroundColor: Colors.white)),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamProvider.value(
      value: AuthService().user,
      child: LandingPage(),
    );
  }
}
