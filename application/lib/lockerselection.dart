import 'package:flutter/material.dart';
import 'locker.dart';

class LockerSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '사물함 선택',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.count(
        crossAxisCount: 4,
        children: List.generate(16, (index) {
          bool available = (index % 3 != 0);
          Color color = available ? Colors.green : Colors.red;
          String status = available ? '예약 가능' : '예약 불가능';
          return GestureDetector(
            onTap: () {
              if (available) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    int selectedHours = 1;
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return AlertDialog(
                          title: Text('${index + 1} 번 사물함을 예약하시겠습니까?',
                                  style: TextStyle(fontSize: 19),),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('사용할 시간을 선택해주세요 :',
                                  style: TextStyle(fontSize: 18),),
                              SizedBox(height: 16.0),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      if (selectedHours > 1) {
                                        setState(() {
                                          selectedHours--;
                                        });
                                      }
                                    },
                                  ),
                                  Text(
                                    '$selectedHours 시간',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      if (selectedHours < 10) {
                                        setState(() {
                                          selectedHours++;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('취소'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('예약하기'),
                              onPressed: () {
                                // 로그인 버튼 클릭 시 메인 화면으로 이동
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LockerPage()),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              } else {
                // 화면 하단에 간단한 메시지 출력
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('해당 사물함은 현재 다른 사람이 사용 중입니다.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            // 네모 박스 안에 표시할 내용
            child: Container(
              margin: EdgeInsets.all(5),
              color: color,
              child: Center(
                child: Text(
                  'No. ${index + 1}\n$status',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}