import 'package:flutter/material.dart';

class PlacePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Place',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body : Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/map.jpg'),
          ),
        ),
      ),
    );
  }
}