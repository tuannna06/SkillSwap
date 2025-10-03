import 'package:flutter/material.dart';
import 'package:cs222_final/components/custom_app_bar.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Notifications'),
      body: const Center(
        child: Text('Notifications Page!', style: TextStyle(fontSize: 12)),
      ),
    );
  }
}
