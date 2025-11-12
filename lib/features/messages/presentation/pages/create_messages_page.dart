import 'package:flutter/material.dart';
// import 'package:cs222_final/features/messages/data/datasources/messages_remote_data_source.dart';
// import 'package:cs222_final/features/messages/data/repositories/messages_repository_impl.dart';

// import 'package:cs222_final/features/messages/presentation/bloc/messages_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

class CreateMessagesPage extends StatefulWidget {
  const CreateMessagesPage({super.key});

  @override
  State<CreateMessagesPage> createState() => _CreateMessagesPageState();
}

class _CreateMessagesPageState extends State<CreateMessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messages')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter your message here',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
