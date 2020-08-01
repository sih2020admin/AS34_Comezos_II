import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ikun/Models/UserModel.dart';

class Database {
  final Firestore _firestore = Firestore.instance;

  Future<String> createUser(userModel user) async {
    String retVal = 'error';

    try {
      await _firestore.collection('users').document(user.uid).setData({
        'fullName': user.fullName,
        'email': user.email,
        'accountCreated': Timestamp.now(),
        'uid': user.uid,
        'groupId': user.groupId,
        'status': user.status,
        'verification': 'unverified',
      });
      retVal = 'success';
    } catch (e) {
      print(e);
    }
    return retVal;
  }
}
