import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ikun/shared/custom_button.dart';

class NewAccount extends StatefulWidget {
  @override
  _NewAccountState createState() => _NewAccountState();
}

class _NewAccountState extends State<NewAccount> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  TextEditingController prefix = TextEditingController();
  String uid;
  Future DATA;
  String error = '';
  DocumentReference documentReference;
  var dropdownValue = 'Choose Category';
  var category = [
    'Choose Category',
    'Business',
    'Expense',
    'Friend',
    'General',
    'Income',
    'Individual',
    'Relative'
  ];

  Future<DocumentSnapshot> getDataFromFb() async {
    var user = await FirebaseAuth.instance.currentUser();
    this.uid = user.uid;
    var data =
        await Firestore.instance.collection('users').document(user.uid).get();
    this.documentReference = Firestore.instance.collection(uid).document();
    return data;
  }

  void initState() {
    super.initState();
    DATA = getDataFromFb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
            fontFamily: 'NixieOne',
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.transparent,
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.blue,
                  ),
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.blue,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  selectedItemBuilder: (BuildContext context) {
                    return category.map<Widget>((String item) {
                      return Container(
                        alignment: Alignment.center,
                        width: 220,
                        child: Text(
                          item,
                          style: TextStyle(
                              color: (item == 'Choose Category')
                                  ? Colors.grey[500]
                                  : Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList();
                  },
                  items: category.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            color: value == 'Choose Category'
                                ? Colors.grey
                                : Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                color: Colors.white,
                child: TextField(
                  cursorColor: Colors.blue[500],
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: 'NixieOne',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                color: Colors.white,
                child: TextField(
                  cursorColor: Colors.blue[500],
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: 'NixieOne',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                color: Colors.white,
                child: TextField(
                  cursorColor: Colors.blue[500],
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: 'NixieOne',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                color: Colors.white,
                child: TextField(
                  cursorColor: Colors.blue[500],
                  controller: bodyController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Remark',
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: 'NixieOne',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 70.0),
              CustomButton(
                callback: () async {
                  if (titleController.text.length > 1) {
                    documentReference.setData({
                      'Title': titleController.text,
                      'Body': bodyController.text,
                      'uid': this.uid,
                      'Refid': documentReference.documentID
                    });
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      error = 'Title required';
                    });
                  }
                },
                lol: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Add Account',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Height: 0,
                colour: Colors.blue[500],
              ),
              SizedBox(
                height: 10,
              ),
              Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0)),
            ],
          ),
        ),
      ),
    );
  }
}
