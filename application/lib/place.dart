import 'package:application/lockerselection.dart';
import 'package:flutter/material.dart';

class PlacePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '예약',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: InteractiveViewer(
        boundaryMargin: EdgeInsets.all(20.0), // 줌인&줌아웃의 경계 제한
        minScale: 1.0,  // 최소 배율
        maxScale: 3.0,  // 최대 배율
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
                    MaterialPageRoute(builder: (context) => LockerSelectionPage()),
                  );
                },
                child: Icon(Icons.place),
              ),
            ),
            Positioned(
              top: 330,
              left: 120,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LockerSelectionPage()),
                  );
                },
                child: Icon(Icons.place),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
