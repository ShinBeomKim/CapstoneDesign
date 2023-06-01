import 'package:application/lockerselection_e.dart';
import 'package:flutter/material.dart';
import 'lockerselection_h.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlacePage extends StatefulWidget {
  @override
  _PlacePageState createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  int lockerCountE = 0;
  int lockerCountH = 0;

  Future<void> fetchLockerData() async {
    final responseE = await http.get(Uri.parse('http://orion.mokpo.ac.kr:8494/lockerscount?location=공대 4호관'));
    final responseH = await http.get(Uri.parse('http://orion.mokpo.ac.kr:8494/lockerscount?location=인문대'));

    if (responseE.statusCode == 200 && responseH.statusCode == 200) {
      setState(() {
        lockerCountE = json.decode(responseE.body)['count'];
        lockerCountH = json.decode(responseH.body)['count'];
      });
    } else {
      throw Exception('Failed to load locker data');
    }
  }


  @override
  void initState() {
    super.initState();
    fetchLockerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '예약',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: InteractiveViewer(
        boundaryMargin: EdgeInsets.all(20.0),
        minScale: 1.0,
        maxScale: 3.0,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/mnumap.png'),
                ),
              ),
            ),
            Positioned(
              top: 265,
              left: 180,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LockerSelectionPageE()),
                  );
                },
                child: Column(
                  children: [
                    Icon(Icons.place),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Text('사용가능 : $lockerCountE'),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 330,
              left: 120,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LockerSelectionPageH()),
                  );
                },
                child: Column(
                  children: [
                    Icon(Icons.place),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(5),
                      child: Text('사용가능 : $lockerCountH'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
