import 'messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final String id;
  final List<String> participants;
  final Map<String, dynamic> participantDetails;
  final String lastMessage;
  final String lastMessageSenderId;
  final DateTime? lastMessageTimestamp;
  final DateTime? createdAt;
  final List<Messages>? messages;

  Conversation({
    required this.id,
    required this.participants,
    required this.participantDetails,
    required this.lastMessage,
    required this.lastMessageSenderId,
    this.lastMessageTimestamp,
    this.createdAt,
    this.messages,
  });

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      id: map['id'] as String,
      participants: List<String>.from(map['participants'] ?? []),
      participantDetails: Map<String, dynamic>.from(
        map['participantDetails'] ?? {},
      ),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageSenderId: map['lastMessageSenderId'] ?? '',
      lastMessageTimestamp: map['lastMessageTimestamp'] != null
          ? (map['lastMessageTimestamp'] as Timestamp).toDate()
          : null,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      messages: map['messages'] != null
          ? List<Messages>.from(
              (map['messages'] as List).map(
                (msg) => Messages.fromMap(msg, msg['id']),
              ),
            )
          : <Messages>[],
    );
  }
}
