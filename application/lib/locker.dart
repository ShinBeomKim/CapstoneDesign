import 'package:flutter/material.dart';

class LockerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '나의 사물함',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Text('예약한 사물함이 없습니다.', style: TextStyle(fontSize: 20),),
        )
    );
  }
}