import 'package:flutter/material.dart';

class ProgramInfoPage extends StatelessWidget {
  // 프로그램 정보 화면
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '프로그램 정보',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '프로그램 정보',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              '버전: 1.7.5',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '개발: Deep Fake',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '이메일: deepfake@mokpo.ac.kr',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              '소개: 앱을 통해 공용 사물함을 쉽게 이용할 수 있습니다.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}