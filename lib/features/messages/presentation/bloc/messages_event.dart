import 'package:equatable/equatable.dart';

abstract class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object> get props => [];
}

class LoadMessages extends MessagesEvent {
  final String conversationId;

  const LoadMessages(this.conversationId);

  @override
  List<Object> get props => [conversationId];
}

class SendMessage extends MessagesEvent {
  final String conversationId;
  final String text;

  const SendMessage(this.conversationId, this.text);

  @override
  List<Object> get props => [conversationId, text];
}