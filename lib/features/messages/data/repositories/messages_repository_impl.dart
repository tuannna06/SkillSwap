import 'package:cs222_final/features/messages/data/datasources/messages_remote_data_source.dart';
import 'package:cs222_final/features/messages/domain/entities/messages.dart';
import 'package:cs222_final/features/messages/domain/repositories/messages_repository.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  final MessagesRemoteDataSource messagesRemoteDataSource;

  MessagesRepositoryImpl({required this.messagesRemoteDataSource});

  @override
  Future<List<Messages>> getMessages(String conversationId) async {
    // Use the remote data source stream and take the current snapshot
    final stream = messagesRemoteDataSource.getConversations(conversationId);
    final list = await stream.first; // first emission
    return list
        .map((m) => Messages.fromMap({
              'senderId': m['senderId'],
              'text': m['text'],
              'timestamp': m['timestamp'],
            },
            m['id']))
        .toList();
  }

  @override
  Future<void> sendMessage(String conversationId, Messages message) async {
    await messagesRemoteDataSource.sendMessage(conversationId, message.toMap());
  }


}
