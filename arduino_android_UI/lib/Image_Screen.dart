import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Screen'),
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