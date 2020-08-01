import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ikun/Pages/LoginPage.dart';
import 'package:ikun/Pages/RegistrationPage.dart';
import 'package:ikun/Pages/next.dart';
import 'package:ikun/shared/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      routes: {
        LoginPage.id: (content) => LoginPage(),
        RegistrationPage.id: (context) => RegistrationPage(),
        Next.id: (context) => Next(),
      },
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
            image: AssetImage("assets/Ikun.png"), fit: BoxFit.fitWidth),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Loading(),
      ),
    );
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      navigateUser(); //It will redirect  after 3 seconds
    });
  }

  void navigateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var check = prefs.getBool('Login');
    var a = await FirebaseAuth.instance.currentUser();
    if (a == null) {
      print('user not found');
      Navigator.of(context).pushReplacementNamed(LoginPage.id);
    } else {
      print('user found');
      if (check) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Next(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacementNamed(LoginPage.id);
      }
    }
  }
}
