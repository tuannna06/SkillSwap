import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesRemoteDataSource {
  final messageCollection = FirebaseFirestore.instance.collection('messages');

  Future<void> sendMessage(String conversationId, Map<String, dynamic> messageData) async {
    await messageCollection
        .doc(conversationId)
        .collection('messages')
        .add(messageData);
  }

  Stream<List<Map<String, dynamic>>> getMessages(String conversationId) {
    return messageCollection
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
