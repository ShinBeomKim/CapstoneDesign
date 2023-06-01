import 'package:flutter/material.dart';
import 'login.dart';
import 'place.dart';
import 'locker.dart';
import 'more.dart';

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

class MyPage extends StatefulWidget {
  final int currentPageIndex;

  MyPage({required this.currentPageIndex});

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<MyPage> {
  int _currentPageIndex = 0; // 현재 페이지 인덱스 (0: Place, 1: Lock, 2: More)

  final List<Widget> _pages = [
    PlacePage(),
    Locker(),
    MorePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.currentPageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPageIndex],
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(
                  _currentPageIndex == 0 ? Icons.place : Icons.place_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _currentPageIndex = 0;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  _currentPageIndex == 1 ? Icons.lock : Icons.lock_outline,
                ),
                onPressed: () {
                  setState(() {
                    _currentPageIndex = 1;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  _currentPageIndex == 2 ? Icons.more_horiz : Icons.more_horiz_outlined,
                ),
                onPressed: () {
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
