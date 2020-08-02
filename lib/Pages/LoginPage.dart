import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ikun/Models/UserModel.dart';
import 'package:ikun/Pages/RegistrationPage.dart';
import 'package:ikun/Pages/imo_next.dart';
import 'package:ikun/Pages/shg_next.dart';
import 'package:ikun/shared/custom_button.dart';
import 'package:ikun/shared/database.dart';
import 'package:ikun/shared/loading.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'LoginPage';
  String Model;

  LoginPage({this.Model});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String error = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> loginUser() async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<FirebaseUser> googlesignin() async {
    try {
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: gSA.accessToken,
        idToken: gSA.idToken,
      );
      FirebaseUser user1 = (await _auth.signInWithCredential(credential)).user;
      if (user1.metadata.creationTime == user1.metadata.lastSignInTime) {
        userModel _user = userModel();
        _user.uid = user1.uid;
        _user.email = user1.email;
        _user.fullName = user1.displayName;
        _user.status = 'user';
        _user.groupId = 'none';
        _user.verification = 'unverified';
        Database().createUser(_user);
      }
      return user1;
    } catch (e) {
      return null;
    }
  }

  String emailValidation(String str) {
    if (validator.email(str)) {
      return null;
    } else if (str.length == 0) {
      return 'Email required';
    } else {
      return 'Enter a valid email!';
    }
  }

  String passwordValidation(String str) {
    if (validator.password(str)) {
      return null;
    } else if (str.length == 0) {
      return 'Password required';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    return loading
        ? Loading()
        : Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(widget.Model == 'Imo'
                      ? "assets/Shg_background.png"
                      : "assets/Imo_background.png"),
                  fit: BoxFit.cover),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 13.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NixieOne'),
                      ),
                      SizedBox(height: 35.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          'Welcome back,\nplease login\nto your account',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'NixieOne',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 35.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'NixieOne',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              validator: (val) => emailValidation(val),
                            ),
                            SizedBox(height: 15.0),
                            TextFormField(
                              controller: passwordController,
                              autocorrect: false,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'NixieOne',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              validator: (val) => passwordValidation(val),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                InkWell(
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blueAccent,
                                      fontFamily: 'NixieOne',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: CustomButton(
                                    Height: 0.0,
                                    lol: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontFamily: 'NixieOne',
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2.0,
                                      ),
                                    ),
                                    colour: Colors.blueAccent,
                                    callback: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() => loading = true);
                                        FirebaseUser user = await loginUser();
                                        if (user == null) {
                                          setState(() {
                                            loading = false;
                                            error =
                                                'Could not sign in with current credentials';
                                          });
                                        } else {
                                          setState(() {
                                            loading = false;
                                          });
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.setBool('Login', true);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Shg_Next(),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Text(error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0)),
                      Row(children: <Widget>[
                        Expanded(
                          child: new Container(
                              margin: const EdgeInsets.only(
                                  left: 50.0, right: 15.0),
                              child: Divider(
                                color: Colors.black,
                                height: 50,
                              )),
                        ),
                        Text(
                          "OR",
                          style: TextStyle(fontSize: 12),
                        ),
                        Expanded(
                          child: new Container(
                            margin:
                                const EdgeInsets.only(left: 15.0, right: 50.0),
                            child: Divider(
                              color: Colors.black,
                              height: 50,
                            ),
                          ),
                        ),
                      ]),
                      SizedBox(height: 8.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 60.0),
                              child: CustomButton(
                                Height: 0.0,
                                lol: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/google.png",
                                      height: 25,
                                      width: 25,
                                    ),
                                    Opacity(
                                      opacity: 0.50,
                                      child: Text(
                                        'Log in with Google',
                                        style: TextStyle(
                                            fontFamily: 'NixieOne',
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5),
                                      ),
                                    ),
                                  ],
                                ),
                                colour: Colors.white,
                                callback: () async {
                                  setState(() => loading = true);
                                  FirebaseUser user = await googlesignin();
                                  if (user == null) {
                                    setState(() {
                                      loading = false;
                                      error =
                                          'Some error occured, please try again later';
                                    });
                                  } else {
                                    setState(() {
                                      loading = false;
                                    });
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool('Login', true);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            widget.Model == 'Shg'
                                                ? Shg_Next()
                                                : Imo_Next(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Don\'t have an account? ',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'NixieOne',
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacementNamed(RegistrationPage.id);
                              },
                              child: Text(
                                ' Sign Up',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'NixieOne',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
