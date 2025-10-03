import 'package:flutter/material.dart';
import 'package:cs222_final/components/custom_app_bar.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Posts'),
      body: const Center(
        child: Text('Posts Page!', style: TextStyle(fontSize: 12)),
      ),
    );
  }
}
