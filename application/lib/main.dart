import 'package:flutter/material.dart';
import 'login.dart';
import 'place.dart';
import 'lock.dart';
import 'more.dart';

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

class MyPage extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<MyPage> {
  int _currentPageIndex = 0; // 현재 페이지 인덱스 (0: Place, 1: Lock, 2: More)

  final List<Widget> _pages = [
    PlacePage(),
    LockPage(),
    MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPageIndex], // 현재 페이지에 맞는 body 영역 표시
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.place),
                onPressed: () {
                  // 'Place' 아이콘을 클릭할 때 현재 페이지 인덱스를 0으로 설정하여 Map 페이지로 전환
                  setState(() {
                    _currentPageIndex = 0;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.lock),
                onPressed: () {
                  // 'Lock' 아이콘을 클릭할 때 현재 페이지 인덱스를 1로 설정하여 Lock 페이지로 전환
                  setState(() {
                    _currentPageIndex = 1;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () {
                  // 'More' 아이콘을 클릭할 때 현재 페이지 인덱스를 2로 설정하여 More 페이지로 전환
                  setState(() {
                    _currentPageIndex = 2;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}