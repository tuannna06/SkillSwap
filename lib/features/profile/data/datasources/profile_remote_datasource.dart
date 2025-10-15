import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileRemoteDatasource {
  final userCollection = FirebaseFirestore.instance.collection('users');
  Future<Map<String, dynamic>> getUserData(String userId) async {
    final DocumentSnapshot doc = await userCollection.doc(userId).get();
    if (!doc.exists) {
      throw Exception('User not found');
    }
    return doc.data() as Map<String, dynamic>;
  }

  Stream<Map<String, dynamic>> getUserProfileStream(String userId) {
    return userCollection.doc(userId).snapshots().map((doc) {
      if (!doc.exists) {
        throw Exception('User not found');
      }
      return doc.data() as Map<String, dynamic>;
    });
  }


}
