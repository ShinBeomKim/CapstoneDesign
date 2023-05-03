import 'package:flutter/material.dart';

class AnnouncementPage extends StatefulWidget {
  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class Announcement {
  final String title;
  final String date;
  final String content;

  Announcement({required this.title, required this.date, required this.content});
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  List<Announcement> announcementList = [
    Announcement(title: '1.7.5 업데이트 안내', date: '2023-04-15', content: '로그아웃 기능추가'),
    Announcement(title: '1.7.0 업데이트 안내', date: '2023-04-01', content: '문의하기 기능추가'),
    Announcement(title: '1.6.5 업데이트 안내', date: '2023-03-15', content: '알람설정 기능추가'),
    Announcement(title: '1.6.0 업데이트 안내', date: '2023-03-01', content: '1.6.0 업데이트 안내'),
    Announcement(title: '1.5.5 업데이트 안내', date: '2023-02-15', content: '1.5.5 업데이트 안내'),
    Announcement(title: '1.5.0 업데이트 안내', date: '2023-02-01', content: '1.5.0 업데이트 안내'),
    Announcement(title: '1.4.5 업데이트 안내', date: '2023-01-15', content: '1.4.5 업데이트 안내'),
    Announcement(title: '1.4.0 업데이트 안내', date: '2023-01-01', content: '1.4.0 업데이트 안내'),
    Announcement(title: '1.3.5 업데이트 안내', date: '2022-12-15', content: '1.3.5 업데이트 안내'),
    Announcement(title: '1.3.0 업데이트 안내', date: '2022-12-01', content: '1.3.0 업데이트 안내'),
    Announcement(title: '1.2.5 업데이트 안내', date: '2022-11-15', content: '1.2.5 업데이트 안내'),
    Announcement(title: '1.2.0 업데이트 안내', date: '2022-11-01', content: '1.2.0 업데이트 안내'),
    Announcement(title: '1.1.5 업데이트 안내', date: '2022-10-15', content: '1.1.5 업데이트 안내'),
    Announcement(title: '1.1.0 업데이트 안내', date: '2022-10-01', content: '1.1.0 업데이트 안내'),
    Announcement(title: '1.0.5 업데이트 안내', date: '2022-09-15', content: '1.0.5 업데이트 안내'),
  ];

  int currentPage = 1;

  // 공지사항 목록을 표시할 ListView 위젯
  Widget _buildAnnouncementList() {
    // 현재 페이지에 해당하는 공지사항들을 리스트로 추출
    List<Announcement> currentPageList = [];
    int startIndex = (currentPage - 1) * 5;
    int endIndex = startIndex + 5;
    for (int i = startIndex; i < endIndex && i < announcementList.length; i++) {
      currentPageList.add(announcementList[i]);
    }

    // 공지사항 레이아웃?
    return ListView.builder(
      itemCount: currentPageList.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(currentPageList[index].title),
            subtitle: Text(currentPageList[index].date),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(currentPageList[index].title),
                    content: Text(currentPageList[index].content),
                    actions: [
                      TextButton(
                        child: Text('확인'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  // 공지하기 화면
  @override
  Widget build(BuildContext context) {
    int maxPage = (announcementList.length / 5).ceil();

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '공지사항',
            style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildAnnouncementList(),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    // 이전 페이지로 이동
                    if (currentPage > 1) {
                      setState(() {
                        currentPage--;
                      });
                    }
                  },
                ),
                Text(
                  '$currentPage',
                  style: TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    // 다음 페이지로 이동
                    if (currentPage < maxPage) {
                      setState(() {
                        currentPage++;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}