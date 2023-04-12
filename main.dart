import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        appBar: AppBar(
          title: Text('Smart Loker'),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: [
            IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  print('account clicked');
            },)
          ],),
        body: Container(
          margin: EdgeInsets.all(20),
            child: Text('라커 메인')),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.lock),
                Icon(Icons.place),
                Icon(Icons.more_horiz),
              ],
            ),
          ),
        ),
      )
    );
  }
}
