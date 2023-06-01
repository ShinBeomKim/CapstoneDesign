import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isIncorrect = false;

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://orion.mokpo.ac.kr:8494/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'student_number': _idController.text,
        'birth_date': _passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _idController.text);  // 로그인 성공 시 아이디 저장

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyPage(currentPageIndex: 0)),
      );
    } else {
      setState(() {
        _isIncorrect = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 기존 UI 구성은 유지하되, TextField 위젯을 TextFormField로 변경합니다.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/mnu.png', // 이미지 파일 경로
              width: 150, // 이미지의 가로 크기
              height: 150, // 이미지의 세로 크기
            ),
            SizedBox(height: 16),
            Text(
              'Public Locker',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: '아이디',
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  errorText: _isIncorrect ? '아이디 또는 비밀번호가 일치하지 않습니다.' : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _login();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.teal, // 버튼 색상을 teal색으로 설정
              ),
              child: Text(
                '로그인',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}