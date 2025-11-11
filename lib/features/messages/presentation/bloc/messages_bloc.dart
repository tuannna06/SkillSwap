import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cs222_final/features/messages/presentation/bloc/messages_event.dart';
import 'package:cs222_final/features/messages/presentation/bloc/messages_state.dart';
import 'package:cs222_final/features/messages/domain/repositories/messages_repository.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final MessagesRepository repository;

  MessagesBloc({required this.repository})
    : super(MessagesInitial()); //constructor
}
