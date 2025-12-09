import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cs222_final/features/messages/data/datasources/messages_remote_data_source.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateMessagesPage extends StatefulWidget {
  final String userId; // the conversation peer's id
  final String username;
  final String conversationId;

  const CreateMessagesPage({
    super.key,
    required this.userId,
    required this.username,
    required this.conversationId,
  });

  @override
  State<CreateMessagesPage> createState() => _CreateMessagesPageState();
}

class _CreateMessagesPageState extends State<CreateMessagesPage> {
  final TextEditingController _controller = TextEditingController();
  final MessagesRemoteDataSource _remote = MessagesRemoteDataSource();
  final List<Map<String, dynamic>> _messages = [];
  IO.Socket? _socket;

  String? _currentUserId;
  bool _intentionalDisconnect = false;
  // Tracks which peer's room we've already joined on the current socket connection
  String? _joinedPeerId;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _currentUserId = user?.uid;
    _remote.getConversation(widget.conversationId).then((list) {
      setState(() {
        _messages.clear();
        for (final m in list) {
          _messages.add({
            'id': m['id'],
            'senderId': m['senderId'],
            'text': m['text'],
            'timestamp': m['timestamp'],
          });
        }
      });
    }).catchError((e) {
      // ignore load error for now or optionally show a snackbar
    });

    _setupSocket();
  }

  @override
  void didUpdateWidget(covariant CreateMessagesPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the conversation or peer changed, reload messages once and rejoin the room.
    if (oldWidget.conversationId != widget.conversationId || oldWidget.userId != widget.userId) {
      // reload messages for the new conversation
      _remote.getConversation(widget.conversationId).then((list) {
        setState(() {
          _messages.clear();
          for (final m in list) {
            _messages.add({
              'id': m['id'],
              'senderId': m['senderId'],
              'text': m['text'],
              'timestamp': m['timestamp'],
            });
          }
        });
      }).catchError((_) {});

      // ensure socket exists and is connected; if not, set it up
      if (_socket == null || !(_socket?.connected ?? false)) {
        _setupSocket();
      } else if (_currentUserId != null && _joinedPeerId != widget.userId) {
        // already connected but switching peer: emit join for the new peer
        try {
          _socket?.emit('join_chat', {
            'my_id': _currentUserId,
            'other_id': widget.userId,
          });
          _joinedPeerId = widget.userId;
        } catch (_) {}
      }
    }
  }

  void _setupSocket() {
    try {
      // if there's an existing socket instance, disconnect and remove listeners
      if (_socket != null) {
        try {
          _socket?.off('connect');
          _socket?.off('receive_message');
          _socket?.off('connect_error');
          _socket?.off('disconnect');
        } catch (_) {}
        try {
          _socket?.disconnect();
        } catch (_) {}
      }

      // creating a fresh socket -> not an intentional disconnect, reset joined peer
      _intentionalDisconnect = false;
      _joinedPeerId = null;

      _socket = IO.io('http://localhost:5000', <String, dynamic>{
        'transports': ['websocket', 'polling'],
        'reconnection': true,
        'reconnectionAttempts': 10,
        'reconnectionDelay': 1000,
      });

      _socket?.on('connect', (_) {
        // join room for this conversation only if we haven't already joined this peer
        if (_currentUserId != null && _joinedPeerId != widget.userId) {
          _socket?.emit('join_chat', {
            'my_id': _currentUserId,
            'other_id': widget.userId,
          });
          _joinedPeerId = widget.userId;
        }
      });

      _socket?.on('connect_error', (err) {
        // connection failed; only attempt reconnect when not intentionally disconnected
        if (!_intentionalDisconnect) {
          try {
            _socket?.connect();
          } catch (_) {}
        }
      });

      _socket?.on('disconnect', (reason) {
        // only auto-reconnect when this wasn't an intentional disconnect
        if (!_intentionalDisconnect) {
          try {
            _socket?.connect();
          } catch (_) {}
        }
      });

      _socket?.on('receive_message', (data) {
        // Expect data: {'from': senderId, 'message': message}
        if (data == null) return;
        final from = data['from'];
        final messageText = data['message'];
        setState(() {
          _messages.insert(0, {
            'id': DateTime.now().microsecondsSinceEpoch.toString(),
            'senderId': from,
            'text': messageText,
            'timestamp': Timestamp.now(),
          });
        });
      });

      // ensure it attempts to connect
      try {
        _socket?.connect();
      } catch (_) {}
    } catch (e) {
      // ignore socket setup errors for now
    }
  }

  @override
  void dispose() {
    // mark intentional disconnect to avoid auto-reconnect when leaving the chat
    _intentionalDisconnect = true;
    try {
      _socket?.disconnect();
    } catch (_) {}
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _currentUserId == null) return;

    // optimistic add
    setState(() {
      _messages.insert(0, {
        'id': DateTime.now().microsecondsSinceEpoch.toString(),
        'senderId': _currentUserId,
        'text': text,
        'timestamp': Timestamp.now(),
      });
    });

    _controller.clear();

    // write to Firestore
    final messageData = {
      'senderId': _currentUserId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    };
    try {
      await _remote.sendMessage(widget.conversationId, messageData);
    } catch (e) {
      // handle write error; for now ignore
    }

    // send to our socket server so other clients in room get notified
    try {
      _socket?.emit('send_message', {
        'to': widget.userId,
        'message': text,
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text(widget.username.isNotEmpty ? widget.username[0].toUpperCase() : '?'),
            ),
            const SizedBox(width: 10),
            Text(widget.username),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Column(
        children: [
          // messages
          Expanded(
            child: _messages.isEmpty
                ? Center(child: Text('No messages'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isMe = msg['senderId'] == _currentUserId;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[300] : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
                              bottomRight: isMe ? Radius.zero : const Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            msg['text'] ?? '',
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

          // input message
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
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
