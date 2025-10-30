import 'package:flutter/material.dart';
import 'package:cs222_final/features/messages/domain/entities/messages_entity.dart';
import 'package:cs222_final/features/messages/presentation/bloc/messages_bloc.dart';
import 'package:cs222_final/features/messages/presentation/bloc/messages_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateMessagesPage extends StatefulWidget {
  const CreateMessagesPage({super.key});

  @override
  State<CreateMessagesPage> createState() => _CreateMessagesPageState();
}

class _CreateMessagesPageState extends State<CreateMessagesPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Enter your message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final messageText = _messageController.text;
                if (messageText.isNotEmpty) {
                  context.read<MessagesBloc>().add(SendMessageEvent(messageText));
                  Navigator.pop(context);
                }
              },
              child: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}