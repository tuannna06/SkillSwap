import 'package:cs222_final/features/messages/data/datasources/messages_remote_data_source.dart';
import 'package:cs222_final/features/messages/data/repositories/messages_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cs222_final/components/custom_app_bar.dart';

import 'package:cs222_final/features/messages/presentation/bloc/messages_bloc.dart';

import 'package:cs222_final/features/messages/presentation/pages/create_messages_page.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessagesBloc>(
      create: (context) => MessagesBloc(
        repository: MessagesRepositoryImpl(
          messagesRemoteDataSource: MessagesRemoteDataSource(),
        ),
      ),

      child: Scaffold(
        appBar: CustomAppBar(title: 'Messages'),
        body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: const NetworkImage(
                  '/assets/images/google_logo.png',
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'User ${index + 1}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'random date',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                'This is a dummy message from user ${index + 1}.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
              onTap: () {
                final messageBloc = context.read<MessagesBloc>();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: messageBloc,
                      child: CreateMessagesPage(),
                    ),
                  ),
                );
              },
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 2,
              ),
              shape: const Border(
                bottom: BorderSide(
                  color: Color.fromRGBO(158, 158, 158, 0.3),
                  width: 0.5,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
