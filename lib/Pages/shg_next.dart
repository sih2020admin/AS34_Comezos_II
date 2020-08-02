import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ikun/Pages/newAccount.dart';
import 'package:ikun/main.dart';
import 'package:ikun/shared/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Shg_Next extends StatefulWidget {
  static const String id = 'Next';
  @override
  _Shg_NextState createState() => _Shg_NextState();
}

class _Shg_NextState extends State<Shg_Next> {
  FirebaseUser user;
  int Index = 0;
  String fullName;
  String uid;
  String email;
  String groupId;
  String status;
  String verification;
  var streamSnapshots;
  var groupSnapshots;
  Future DATA;
  String error;
  TextEditingController _phoneController = TextEditingController();
  _sendEmail(String body) async {
    final String _email =
        'mailto:teamcomezos@gmail.com?subject=Verification Submission&body=' +
            body;
    try {
      await launch(_email);
    } catch (e) {
      throw 'Could not Call Phone';
    }
  }

  void initState() {
    super.initState();
    DATA = getDataFromFb();
  }

  Future<DocumentSnapshot> getDataFromFb() async {
    this.user = await FirebaseAuth.instance.currentUser();
    this.uid = this.user.uid;
    var data = await Firestore.instance
        .collection('users')
        .document(this.user.uid)
        .get();
    this.email = data['email'];
    this.verification = data['verification'];
    this.fullName = data['fullName'];
    this.groupId = data['groupId'];
    this.status = data['status'];
    this.verification = data['verification'];
    this.streamSnapshots = Firestore.instance.collection(this.uid).snapshots();
    this.groupSnapshots = Firestore.instance
        .collection('users')
        .where('groupId', isEqualTo: this.groupId)
        .snapshots();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    List tabContent = [
      //page1
      Column(
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[],
            ),
          ),
        ],
      ),
      //page2
      this.verification == 'verified'
          ? this.groupId == 'none'
              ? Center(
                  heightFactor: 10.0,
                  child: Opacity(
                    opacity: 0.50,
                    child: Text(
                      'This Feature is not available for your account.',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NixieOne',
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : StreamBuilder<QuerySnapshot>(
                  stream: this.groupSnapshots,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Center(child: Text('Loading...'));
                      default:
                        if (snapshot.data.documents.length != 0) {
                          return Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                margin:
                                    EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 10.0),
                                constraints: BoxConstraints(
                                    minWidth: MediaQuery.of(context).size.width,
                                    maxWidth: MediaQuery.of(context).size.width,
                                    minHeight: 40.0),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0.5,
                                      blurRadius: 2,
                                    ),
                                  ],
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[100],
                                      Colors.cyan[100]
                                    ],
                                  ),
                                ),
                                child: Text(
                                  'Group Name',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'NixieOne',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Members',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'NixieOne',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ListView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot document) {
                                  return Opacity(
                                    opacity: 0.90,
                                    child: Card(
                                      elevation: 3.0,
                                      color: Colors.blue[500],
                                      shadowColor: Colors.blue[300],
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 7.0),
                                        child: ListTile(
                                          title: Text(
                                            document['fullName'],
                                            style: TextStyle(
                                              fontSize: 21.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'NixieOne',
                                              color: Colors.white,
                                            ),
                                          ),
                                          subtitle: Opacity(
                                            opacity: 0.70,
                                            child: Text(
                                              document['uid'],
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'NixieOne',
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: <Widget>[
                              Center(
                                heightFactor: 10.0,
                                child: Opacity(
                                  opacity: 0.50,
                                  child: Text(
                                    'No Accounts yet',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'NixieOne',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                    }
                  },
                )
          : Column(
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            title: Center(
                              child: Text('Verify'),
                            ),
                            content: Container(
                              height: 155,
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'Our professional team will contact you within 48 hours.',
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'You might be asked for documents OR a meet in person',
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'Enter your phone',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              Text(
                                'Phone number needed!    ',
                                style: TextStyle(color: Colors.red),
                              ),
                              Container(
                                child: FlatButton(
                                  onPressed: () {
                                    if (_phoneController.text.length == 10) {
                                      _sendEmail('ID:' +
                                          this.uid +
                                          '\nName:' +
                                          this.fullName +
                                          '\nPhone:' +
                                          _phoneController.text);
                                    }
                                  },
                                  child: Text(
                                    'Send Email',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(8.0),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[300],
                                      Colors.blue[300]
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 10.0),
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                        maxWidth: MediaQuery.of(context).size.width,
                        minHeight: 40.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12.0),
                      gradient: LinearGradient(
                        colors: [Colors.red[200], Colors.pink[100]],
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.warning,
                          size: 30,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          'Verify Now',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'NixieOne',
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        )
                      ],
                    ),
                  ),
                ),
                Center(
                  heightFactor: 10.0,
                  child: Opacity(
                    opacity: 0.50,
                    child: Text(
                      'Not Verified!',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NixieOne',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),

      //page3
      StreamBuilder<QuerySnapshot>(
        stream: this.streamSnapshots,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: Text('Loading...'));
            default:
              if (snapshot.data.documents.length != 0) {
                return Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewAccount(),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 10.0),
                        constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width,
                            maxWidth: MediaQuery.of(context).size.width,
                            minHeight: 40.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12.0),
                          gradient: LinearGradient(
                            colors: [Colors.blue[100], Colors.cyan[100]],
                          ),
                        ),
                        child: Text(
                          'Add Account',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'NixieOne',
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return Opacity(
                          opacity: 0.90,
                          child: Card(
                            elevation: 10.0,
                            color: Colors.blue[500],
                            shadowColor: Colors.blue[300],
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 7.0),
                              child: ListTile(
                                title: Text(
                                  document['Title'],
                                  style: TextStyle(
                                    fontSize: 21.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'NixieOne',
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Opacity(
                                  opacity: 0.70,
                                  child: Text(
                                    document['Body'],
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'NixieOne',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () async {
                                    await Firestore.instance
                                        .collection(this.uid)
                                        .document(document['Refid'])
                                        .delete();
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewAccount(),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 10.0),
                        constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width,
                            maxWidth: MediaQuery.of(context).size.width,
                            minHeight: 40.0),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12.0),
                          gradient: LinearGradient(
                            colors: [Colors.blue[100], Colors.cyan[100]],
                          ),
                        ),
                        child: Text(
                          'Add Account',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'NixieOne',
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      heightFactor: 10.0,
                      child: Opacity(
                        opacity: 0.50,
                        child: Text(
                          'No Accounts yet',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NixieOne',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
          }
        },
      ),

      //page4
      Column(
        children: <Widget>[],
      ),
    ];

    return FutureBuilder(
        future: DATA,
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: Loading(),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  'Error!',
                  style: TextStyle(fontSize: 13.0),
                ));
              } else {
                return DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      title: Text('Welcome ${this.fullName.split(' ')[0]}!',
                          style: TextStyle(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NixieOne',
                            color: Colors.black,
                          )),
                      elevation: 0.0,
                      backgroundColor: Colors.white,
                      leading: Image.asset('assets/logo.png'),
                      actions: <Widget>[
                        Row(
                          children: <Widget>[
                            Opacity(
                              opacity: 0.50,
                              child: Text(
                                'Exit',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('Login', false);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InitialRoute(),
                                  ),
                                );
                              },
                              icon: Icon(
                                // ignore: missing_return
                                Icons.exit_to_app,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    body: SingleChildScrollView(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: tabContent[Index],
                      ),
                    ),
                    bottomNavigationBar: BottomNavigationBar(
                      currentIndex: Index,
                      type: BottomNavigationBarType.fixed,
                      items: [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          title: Text('Home',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NixieOne',
                                color: Colors.black,
                              )),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.group),
                          title: Text('Group',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NixieOne',
                                color: Colors.black,
                              )),
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.library_books),
                          title: Text('Accounts',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NixieOne',
                                color: Colors.black,
                              )),
                        ),
                        BottomNavigationBarItem(
                          title: Text('Profile',
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'NixieOne',
                                color: Colors.black,
                              )),
                          icon: Icon(Icons.person),
                        ),
                      ],
                      onTap: (n) {
                        setState(() {
                          Index = n;
                        });
                      },
                    ),
                  ),
                );
              }
          }
        });
  }
}
