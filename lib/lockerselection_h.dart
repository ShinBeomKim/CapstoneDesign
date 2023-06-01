import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'locker.dart';
import 'main.dart';

class LockerSelectionPageH extends StatefulWidget {
  @override
  _LockerSelectionPageHState createState() => _LockerSelectionPageHState();
}

class _LockerSelectionPageHState extends State<LockerSelectionPageH> {
  late List<int> lockerStatusList;
  String location = '인문대';

  @override
  void initState() {
    super.initState();
    fetchLockerData();
  }

  Future<void> fetchLockerData() async {
    var response = await http.get(
      Uri.parse('http://orion.mokpo.ac.kr:8494/lockersinfo?location=$location'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      lockerStatusList = List<int>.from(data['reserved']);
      setState(() {});
    }
  }

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
        children: List.generate(lockerStatusList.length, (index) {
          bool available = lockerStatusList[index] == 0;
          Color color = available ? Colors.green : Colors.red;
          String status = available ? '예약 가능' : '예약 불가';
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
                              child: Text(
                                '취소',
                                style: TextStyle(fontSize: 18),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(primary: Colors.red),
                            ),
                            TextButton(
                              child: Text(
                                '예약하기',
                                style: TextStyle(fontSize: 18),
                              ),
                              onPressed: () async {
                                var startTime = DateTime.now();
                                var endTime = startTime.add(Duration(hours: selectedHours));

                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                var userId = prefs.getString('userId');

                                var response = await http.post(
                                  Uri.parse('http://orion.mokpo.ac.kr:8494/reservation'),
                                  headers: <String, String>{
                                    'Content-Type': 'application/json; charset=UTF-8',
                                  },
                                  body: jsonEncode(<String, dynamic>{
                                    'locker_number': 'H${index + 1}',
                                    'student_number': userId,
                                    'start_time': startTime.toIso8601String(),
                                    'end_time': endTime.toIso8601String(),
                                  }),
                                );

                                if (response.statusCode == 200) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => MyPage(currentPageIndex: 1)),
                                        (route) => false,
                                  );
                                } else {
                                  throw Exception('예약 실패');
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('해당 사물함은 현재 다른 사람이 사용 중입니다.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            child: Container(
              margin: EdgeInsets.all(5),
              color: color,
              child: Center(
                child: Text(
                  'H${index + 1}\n$status',
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
