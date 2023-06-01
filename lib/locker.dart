import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Locker extends StatefulWidget {
  @override
  _LockerState createState() => _LockerState();
}

class _LockerState extends State<Locker> {
  bool _isLocked = true;
  String lockerNumber = '';
  String location = '';
  late DateTime endTime;
  int reserved = 0;
  int endHour = 0;
  int endMinute = 0;
  String lockerNumberInt = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchLockerData();
    startTimer();
  }

  // 서버로부터 데이터 불러와 변수들 업데이트
  Future<void> fetchLockerData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId'); //사용자 아이디 검색

    var response = await http.get(
      Uri.parse('http://orion.mokpo.ac.kr:8494/reservationinfo?student_number=$userId'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        lockerNumber = data['locker_number'];
        location = data['location'];
        endTime = DateTime.parse(data['end_time']);
        reserved = data['reserved'];
        endHour = endTime.hour; // endTime에서 시간 추출
        endMinute = endTime.minute; // endTime에서 분 추출
        lockerNumberInt = lockerNumber[1];  // 사물함 번호에서 숫자만 추출
      });
    }
  }

  // 현재시간과 종료시간을 비교해서 현재시간이 크면 endreservation 함수 호출
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) async {
        if (DateTime.now().isAfter(endTime)) {
          timer.cancel();
          await endReservation();
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // 사용이 종료될 때 호출하는 함수
  Future<void> endReservation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');

    var response = await http.get(
      Uri.parse('http://orion.mokpo.ac.kr:8494/endreservation?student_number=$userId&locker_number=$lockerNumber'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        reserved = data['reserved'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (reserved == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '나의 사물함',
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Text('예약한 사물함이 없습니다.', style: TextStyle(fontSize: 25),),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '나의 사물함',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$location',
              style: TextStyle(fontSize: 35.0),
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              '$lockerNumberInt번',
              style: TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30.0,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isLocked = !_isLocked;
                });
              },
              child: Container(
                width: 300.0,
                height: 300.0,
                decoration: BoxDecoration(
                  color: _isLocked ? Colors.red : Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _isLocked ? Icons.lock : Icons.lock_open,
                  color: Colors.white,
                  size: 200.0,
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              '종료 시간: $endHour시 $endMinute분',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: 140.0,
              height: 60.0,
              child: ElevatedButton(
                onPressed: () {
                  endReservation();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // 버튼 색상을 검정색으로 설정
                ),
                child: Text(
                  '사용 종료',
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
