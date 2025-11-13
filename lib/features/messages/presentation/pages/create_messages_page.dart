import 'package:flutter/material.dart';
// import 'package:cs222_final/features/messages/data/datasources/messages_remote_data_source.dart';
// import 'package:cs222_final/features/messages/data/repositories/messages_repository_impl.dart';

// import 'package:cs222_final/features/messages/presentation/bloc/messages_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

class CreateMessagesPage extends StatefulWidget {
  final String userId;
  final String username;

  const CreateMessagesPage({
    super.key,
    required this.userId,
    required this.username
    });

  @override
  State<CreateMessagesPage> createState() => _CreateMessagesPageState();
}

class _CreateMessagesPageState extends State<CreateMessagesPage> {
  final TextEditingController _controller = TextEditingController();

  // Temporary dummy messages
  final List<Map<String, dynamic>> _messages = [
    {'sender': 'me', 'text': 'Hey, how are you doing?'},
    {'sender': 'them', 'text': 'All good! You?'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text(widget.username[0].toUpperCase()), // icon
            ),
            const SizedBox(width: 10),
            Text(widget.username),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(
        children: [
          //messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              reverse: true, // newest messages appear at bottom
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[_messages.length - 1 - index];
                final isMe = msg['sender'] == 'me';
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue[300] : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft:
                            isMe ? const Radius.circular(12) : Radius.zero,
                        bottomRight:
                            isMe ? Radius.zero : const Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      msg['text'],
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          //input message
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              color: Colors.white,
              child: Row(
                children: [
                  // Text Input
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Send Button
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () {
                        final text = _controller.text.trim();
                        if (text.isNotEmpty) {
                          setState(() {
                            _messages.add({'sender': 'me', 'text': text});
                          });
                          _controller.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
