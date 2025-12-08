import 'package:cs222_final/features/messages/data/datasources/messages_remote_data_source.dart';
import 'package:cs222_final/features/messages/data/repositories/messages_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cs222_final/components/custom_app_bar.dart';

import 'package:cs222_final/features/messages/presentation/bloc/messages_bloc.dart';

import 'package:cs222_final/features/messages/presentation/pages/create_messages_page.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Messages'),
        body: Center(child: Text('Please sign in to view messages')),
      );
    }

    final messagesRemote = MessagesRemoteDataSource();

    return BlocProvider<MessagesBloc>(
      create: (context) => MessagesBloc(
        repository: MessagesRepositoryImpl(
          messagesRemoteDataSource: messagesRemote,
        ),
      ),
      child: Scaffold(
        appBar: CustomAppBar(title: 'Messages'),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: messagesRemote.getUserConversations(currentUser.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No conversations'));
            }

            final conversations = snapshot.data!;
            return ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final conv = conversations[index];
                // determine other participant
                final participants = List<String>.from(conv['participants'] ?? []);
                final otherId = participants.firstWhere((id) => id != currentUser.uid, orElse: () => '');
                final participantDetails = conv['participantDetails'] ?? {};
                final otherDetails = participantDetails[otherId] ?? {};
                final name = otherDetails['name'] ?? otherId;
                final photo = otherDetails['photoUrl'];
                final lastMessage = conv['lastMessage'] ?? '';

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: (photo != null && photo is String && photo.isNotEmpty)
                        ? NetworkImage(photo)
                        : null,
                    child: (photo == null || (photo is String && photo.isEmpty)) ? Text(name.isNotEmpty ? name[0].toUpperCase() : '?') : null,
                  ),
                  title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () {
                    final messageBloc = context.read<MessagesBloc>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: messageBloc,
                          child: CreateMessagesPage(
                            userId: otherId,
                            username: name,
                            conversationId: conv['id'],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}