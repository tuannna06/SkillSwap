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

  Future<String> createUser(Map<String, dynamic> userData) async {
  try {
    final docRef = await userCollection.add(userData);
    userData['id'] = docRef.id;
    return docRef.id;
  } catch (e) {
    throw Exception('Failed to create user: $e');
  }
}

  Future<void> updateUser(String userId, Map<String, dynamic> updatedData) async {
    try {
      await userCollection.doc(userId).update(updatedData);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await userCollection.doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

}
