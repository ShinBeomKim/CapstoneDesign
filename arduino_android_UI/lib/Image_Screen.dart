import 'package:flutter/material.dart';
import 'another_screen.dart';

class ImageScreen extends StatelessWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Screen'),
      ),
      body: GridView.count(
        crossAxisCount: 4,
        children: List.generate(16, (index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnotherScreen()),
              );
            },
            child: Container(
              color: Colors.blue,
              margin: const EdgeInsets.all(4.0),
              child: const Center(

              ),
            ),
          );
        }),
      ),
    );
  }
}