//import 'package:cs222_final/features/messages/domain/entities/messages_entity.dart';
import 'package:cs222_final/features/messages/domain/entities/messages.dart';

abstract class MessagesRepository {
  Future<List<Messages>> getMessages(String conversationId);
  Future<void> sendMessage(String conversationId, Messages message);
  Future<String> createConversation(List<String> participantIds);
  Future<void> markMessageAsRead(
    String conversationId,
    String messageId,
    String userId,
  );
}
