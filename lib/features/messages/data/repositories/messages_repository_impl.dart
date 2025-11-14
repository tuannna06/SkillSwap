import 'package:cs222_final/features/messages/data/datasources/messages_remote_data_source.dart';
import 'package:cs222_final/features/messages/domain/entities/messages.dart';
import 'package:cs222_final/features/messages/domain/repositories/messages_repository.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  final MessagesRemoteDataSource messagesRemoteDataSource;

  MessagesRepositoryImpl({required this.messagesRemoteDataSource});

  @override
  Future<List<Messages>> getMessages(String conversationId) async {
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessage(String conversationId, Messages message) async {}


}
