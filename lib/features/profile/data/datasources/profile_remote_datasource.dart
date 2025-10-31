import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileRemoteDatasource {
  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<DocumentSnapshot> getUserData(String userId) async {
    final DocumentSnapshot doc = await userCollection.doc(userId).get();
    if (!doc.exists) {
      throw Exception('User not found');
    }
    return doc;
  }

  Stream<DocumentSnapshot> getUserProfileStream(String userId) {
    return userCollection.doc(userId).snapshots().map((doc) {
      if (!doc.exists) {
        throw Exception('User not found');
      }
      return doc;
    });
  }


}
