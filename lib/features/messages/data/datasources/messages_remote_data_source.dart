import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesRemoteDataSource {
  final conversationCollection = FirebaseFirestore.instance.collection(
    'conversations',
  );

  final userCollection = FirebaseFirestore.instance.collection('users');

  // Conversation structure:
  // {
  //   'id': 'conv_123',
  //   'participants': ['user1', 'user2'],
  //   'participantDetails': {
  //     'user1': {'name': 'Alice', 'photoUrl': '...'},
  //     'user2': {'name': 'Bob', 'photoUrl': '...'},
  //   },
  //   'lastMessage': 'Hello!',
  //   'lastMessageSenderId': 'user1',
  //   'lastMessageTimestamp': Timestamp,
  //   'createdAt': Timestamp
  // }

  String getConversationId(String userId1, String userId2) {
    final sorted = [userId1, userId2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  Future<String> createOrGetConversation({
    required List<String> participantIds,
  }) async {
    if (participantIds.length < 2) {
      return Future.error('At least two participants are required');
    }

    String conversationId;
    if (participantIds.length == 2) {
      conversationId = getConversationId(participantIds[0], participantIds[1]);
    } else {
      return Future.error('Group conversations not yet supported');
    }

    final conversationRef = conversationCollection.doc(conversationId);
    final doc = await conversationRef.get();

    if (doc.exists) {
      return conversationId;
    }

    //get participant details
    Map<String, Map<String, dynamic>> participantDetails = {};
    for (String participantId in participantIds) {
      final userDoc = await userCollection.doc(participantId).get();
      if (userDoc.exists) {
        // Use data() and null-safe access because calling get()/indexing can throw
        // if the field is missing. Coerce to map and provide defaults.
        final userData = userDoc.data() as Map?;
        participantDetails[participantId] = {
          'name': userData?['name'] ?? '',
          'photoUrl': userData?['photoUrl'] ?? '',
        };
      } else {
        return Future.error('User $participantId not found');
      }
    }

    await conversationRef.set({
      'id': conversationId,
      'participants': participantIds,
      'participantDetails': participantDetails,
      'lastMessage': '',
      'lastMessageSenderId': '',
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    return conversationId;
  }

  Stream<List<Map<String, dynamic>>> getUserConversations(String userId) {
    return conversationCollection
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'participants': data['participants'],
              'participantDetails': data['participantDetails'],
              'lastMessage': data['lastMessage'],
              'lastMessageSenderId': data['lastMessageSenderId'],
              'lastMessageTimestamp': data['lastMessageTimestamp'],
              'createdAt': data['createdAt'],
            };
          }).toList(),
        );
  }

  Future<void> sendMessage(
    String conversationId,
    Map<String, dynamic> messageData,
  ) async {
    // Ensure messageData contains a timestamp
    if (!messageData.containsKey('timestamp')) {
      messageData['timestamp'] = FieldValue.serverTimestamp();
    }

    await conversationCollection.doc(conversationId).update({
      'lastMessage': messageData['text'],
      'lastMessageSenderId': messageData['senderId'],
      'lastMessageTimestamp': FieldValue.serverTimestamp(),
    });

    await conversationCollection
        .doc(conversationId)
        .collection('messages')
        .add(messageData);
  }

  /// Fetch all messages for a conversation once (not a stream).
  Future<List<Map<String, dynamic>>> getConversation(String conversationId) async {
    final querySnapshot = await conversationCollection
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'text': data['text'],
        'senderId': data['senderId'],
        'timestamp': data['timestamp'],
      };
    }).toList();
  }
}
