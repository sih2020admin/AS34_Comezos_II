import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ikun/Pages/LoginPage.dart';
import 'package:ikun/Pages/RegistrationPage.dart';
import 'package:ikun/Pages/shg_next.dart';
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
        Shg_Next.id: (context) => Shg_Next(),
      },
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InitialRoute(),
        ),
      );
    } else {
      print('user found');
      if (check) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Shg_Next(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => InitialRoute(),
          ),
        );
      }
    }
  }
}

class InitialRoute extends StatefulWidget {
  @override
  _InitialRouteState createState() => _InitialRouteState();
}

class _InitialRouteState extends State<InitialRoute> {
  int x;
  int y;
  bool choice_shg;
  bool choice_imo;
  void initState() {
    super.initState();
    this.x = 1;
    this.y = 1;
    this.choice_shg = false;
    this.choice_imo = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: y,
                child: FlatButton(
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(0),
                  onPressed: choice_shg == false
                      ? () {
                          setState(() {
                            choice_imo = false;
                            choice_shg = true;
                            x = 1;
                            y = y + 10;
                          });
                        }
                      : null,
                  child: Container(
                    height: MediaQuery.of(context).size.height - 40,
                    width: y == 1
                        ? MediaQuery.of(context).size.width / 2 - 1
                        : MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/Stars.png"),
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 2 / 7,
                        ),
                        Text(
                          x == 1 ? 'General' : '',
                          style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NixieOne'),
                        ),
                        SizedBox(
                          height: 316.5,
                        ),
                        y != 1
                            ? Text(
                                'Do you want to continue to\n General Useage?',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NixieOne'),
                              )
                            : SizedBox(),
                        y != 1
                            ? Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LoginPage(Model: 'Shg'),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'NixieOne'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          x = 1;
                                          y = 1;
                                          choice_shg = false;
                                          choice_imo = false;
                                        });
                                      },
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'NixieOne'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.grey[700],
                width: 1.5,
                height: MediaQuery.of(context).size.height - 100,
              ),
              Expanded(
                flex: x,
                child: FlatButton(
                  disabledTextColor: Colors.black,
                  padding: EdgeInsets.all(0),
                  onPressed: choice_imo == false
                      ? () {
                          setState(() {
                            choice_shg = false;
                            choice_imo = true;
                            y = 1;
                            x = x + 10;
                          });
                        }
                      : null,
                  child: Container(
                    width: x == 1
                        ? MediaQuery.of(context).size.width / 2 - 1
                        : MediaQuery.of(context).size.width - 20,
                    height: MediaQuery.of(context).size.height - 40,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/Circles.png"),
                          fit: BoxFit.scaleDown),
                    ),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height * 2 / 7 - 14,
                        ),
                        Text(
                          y == 1 ? 'Intermediary\nOrganization' : '',
                          style: TextStyle(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NixieOne'),
                        ),
                        SizedBox(
                          height: 300,
                        ),
                        x != 1
                            ? Text(
                                'Do you want to continue to\nIntermediary organization?',
                                style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NixieOne'),
                              )
                            : SizedBox(),
                        x != 1
                            ? Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                LoginPage(Model: 'Imo'),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'NixieOne'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          x = 1;
                                          y = 1;
                                          choice_shg = false;
                                          choice_imo = false;
                                        });
                                      },
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'NixieOne'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          x == 1 && y == 1
              ? Text(
                  y == 1 ? 'Click to choose!' : '',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NixieOne'),
                )
              : SizedBox(
                  height: 0,
                  width: 0,
                ),
        ],
      ),
    );
  }
}
