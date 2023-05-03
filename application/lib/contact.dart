import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();

  // 문의하기 화면
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '문의하기',
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
              '문의 사항을 입력해주세요:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: '문의 내용을 입력해주세요',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _sendEmail(context, _messageController.text);
              },
              child: Text('문의 내용 전송'),
            ),
          ],
        ),
      ),
    );
  }

  // 문의 내용 전송 버튼을 눌렀을 때 수행하는 함수
  void _sendEmail(BuildContext context, String message) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'your_email@example.com',
      query: 'subject=문의하기&body=$message',
    );

    if (await canLaunch(params.toString())) {
      await launch(params.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('이메일 앱을 열 수 없습니다.'),
        ),
      );
    }
  }
}