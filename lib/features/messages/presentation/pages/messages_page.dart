import 'package:flutter/material.dart';
import 'package:cs222_final/components/custom_app_bar.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  '3/14/23',
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
            onTap: () {},
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
    );
  }
}
