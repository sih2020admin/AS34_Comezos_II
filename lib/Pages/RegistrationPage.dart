import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ikun/Models/UserModel.dart';
import 'package:ikun/Pages/LoginPage.dart';
import 'package:ikun/Pages/next.dart';
import 'package:ikun/shared/custom_button.dart';
import 'package:ikun/shared/database.dart';
import 'package:ikun/shared/loading.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'RegistrationPage';
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  String error = '';

  Future<FirebaseUser> registerUser() async {
    userModel _user = userModel();
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      _user.uid = result.user.uid;
      _user.email = result.user.email;
      _user.fullName = nameController.text;
      _user.status = 'user';
      _user.groupId = 'none';
      _user.verification = 'unverified';
      Database().createUser(_user);
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<FirebaseUser> googleRegister() async {
    try {
      userModel _user = userModel();
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: gSA.accessToken,
        idToken: gSA.idToken,
      );
      AuthResult result = await _auth.signInWithCredential(credential);
      _user.uid = result.user.uid;
      _user.email = result.user.email;
      _user.fullName = result.user.displayName;
      _user.status = 'user';
      _user.groupId = 'none';
      _user.verification = 'unverified';
      Database().createUser(_user);
      FirebaseUser user = (result).user;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  String emailValidation(String str) {
    if (validator.email(str)) {
      return null;
    } else {
      return 'Enter a valid email!';
    }
  }

  String passwordValidation(String str) {
    if (validator.password(str)) {
      return null;
    } else if (str.length == 0) {
      return 'Password required';
    } else {
      return 'Too weak';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));
    bool loading = false;
    return loading
        ? Loading()
        : Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background.png"),
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
                        'Register',
                        style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NixieOne'),
                      ),
                      SizedBox(height: 35.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          'Let\'s get\nyou on board',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'NixieOne',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Full Name',
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'NixieOne',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              validator: (val) {
                                if (val.length < 1)
                                  return 'Name Required';
                                else
                                  return null;
                              },
                            ),
                            SizedBox(height: 15.0),
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
                            SizedBox(height: 30.0),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: CustomButton(
                                      Height: 0.0,
                                      lol: Text(
                                        'Register',
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
                                          FirebaseUser user =
                                              await registerUser();
                                          if (user == null) {
                                            setState(() {
                                              loading = false;
                                              error =
                                                  'Could not sign up with current credentials';
                                            });
                                          } else {
                                            var info = UserUpdateInfo();
                                            info.displayName =
                                                nameController.text;
                                            await user.updateProfile(info);
                                            await user.reload();
                                            user = await _auth.currentUser();
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setBool('Login', true);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Next(),
                                              ),
                                            );
                                          }
                                        }
                                      }),
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
                              margin: const EdgeInsets.only(
                                  left: 15.0, right: 50.0),
                              child: Divider(
                                color: Colors.black,
                                height: 50,
                              )),
                        ),
                      ]),
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
                                        'Register with Google',
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
                                  FirebaseUser user = await googleRegister();
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
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Next(),
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
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Already have an account? ',
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
                                    .pushReplacementNamed(LoginPage.id);
                              },
                              child: Text(
                                ' Sign in',
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
