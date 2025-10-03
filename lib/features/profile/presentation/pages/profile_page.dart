import 'package:flutter/material.dart';
import 'package:cs222_final/components/custom_app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      body: const Center(
        child: Text('Profile Page!', style: TextStyle(fontSize: 12)),
      ),
    );
  }
}
