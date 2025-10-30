import 'package:equatable/equatable.dart';

abstract class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends MessagesEvent {
  final String messageText;

  const SendMessageEvent(this.messageText);

  @override
  List<Object> get props => [messageText];
}


class MessagesInitial extends MessagesEvent {}

class MessagesLoading extends MessagesEvent {}

class MessagesLoaded extends MessagesEvent {
  final List<Messages> messages;

  const MessagesLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessagesError extends MessagesEvent {
  final String error;

  const MessagesError(this.error);

  @override
  List<Object> get props => [error];
}