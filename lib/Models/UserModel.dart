import 'package:cloud_firestore/cloud_firestore.dart';

class userModel {
  String fullName;
  String uid;
  String email;
  String groupId;
  String status;
  String verification;
  Timestamp accountCreated;

  userModel(
      {this.uid,
      this.accountCreated,
      this.email,
      this.fullName,
      this.groupId,
      this.status,
      this.verification});
}
