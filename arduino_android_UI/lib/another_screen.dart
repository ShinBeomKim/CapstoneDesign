import 'package:flutter/material.dart';

class AnotherScreen extends StatelessWidget {
  const AnotherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Another Screen'),
      ),
      body: Container(
        color: Colors.blue,
        child: const Center(
          child: Text('This is another screen.'),
        ),
      ),
    );
  }
}