import 'package:flutter/material.dart';
import 'package:cs222_final/components/custom_app_bar.dart';
import 'package:cs222_final/features/posts/presentation/pages/create_posts_page.dart'; 

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Posts'),
      body: const Center(
        child: Text('Posts Page!', style: TextStyle(fontSize: 12)),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatePostPage()),
              );
            },
            child: const Text('Click Me'),
          ),
        ],
      )
    );
  }
}