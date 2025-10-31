import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  final String id;
  final String senderId;
  final String text;
  final Timestamp timestamp;

  Messages({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  // Factory method to create a Messages object from Firestore data
  factory Messages.fromMap(Map<String, dynamic> data, String documentId) {
    return Messages(
      id: documentId,
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // Convert a Messages object to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
    };
  }
}