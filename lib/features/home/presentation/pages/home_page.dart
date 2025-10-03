import 'package:flutter/material.dart';
import 'package:cs222_final/components/custom_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Home Page'),
      body: const Center(
        child: Text('Home Page!', style: TextStyle(fontSize: 12)),
      ),
    );
  }
}
