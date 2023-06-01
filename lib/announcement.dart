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

// 공지사항 내용
class _AnnouncementPageState extends State<AnnouncementPage> {
  List<Announcement> announcementList = [
    Announcement(title: '1.7.5 업데이트 안내', date: '2023-06-05', content: '나의 사물함에 남은 시간을 알 수 있도록 남은 시간 추가'),
    Announcement(title: '1.7.0 업데이트 안내', date: '2023-05-29', content: '나의 사물함에 사용 종료 버튼 추가'),
    Announcement(title: '1.6.5 업데이트 안내', date: '2023-05-22', content: '예약화면 지도를 줌인&줌아웃 할 수 있는 기능 추가'),
    Announcement(title: '1.6.0 업데이트 안내', date: '2023-05-15', content: '예약화면 초기화면인 지도에서 사용중인 사물함 개수를 파악할 수 있는 기능 추가'),
    Announcement(title: '1.5.5 업데이트 안내', date: '2023-05-08', content: '로그아웃 기능추가'),
    Announcement(title: '1.5.0 업데이트 안내', date: '2023-05-01', content: '문의하기 기능추가'),
    Announcement(title: '1.4.5 업데이트 안내', date: '2023-04-24', content: '알람설정 기능추가'),
    Announcement(title: '1.4.0 업데이트 안내', date: '2023-04-17', content: '나의 사물함 화면에서 이전 화면인 예약화면으로 돌아가는 오류 수정'),
    Announcement(title: '1.3.5 업데이트 안내', date: '2023-04-11', content: '1.3.5 업데이트 안내'),
    Announcement(title: '1.3.0 업데이트 안내', date: '2023-04-04', content: '1.3.0 업데이트 안내'),
    Announcement(title: '1.2.5 업데이트 안내', date: '2023-03-27', content: '1.2.5 업데이트 안내'),
    Announcement(title: '1.2.0 업데이트 안내', date: '2023-03-20', content: '1.2.0 업데이트 안내'),
    Announcement(title: '1.1.5 업데이트 안내', date: '2023-03-13', content: '1.1.5 업데이트 안내'),
    Announcement(title: '1.1.0 업데이트 안내', date: '2023-03-06', content: '1.1.0 업데이트 안내'),
    Announcement(title: '1.0.5 업데이트 안내', date: '2023-02-20', content: '1.0.5 업데이트 안내'),
  ];

  int currentPage = 1;

  // 공지사항 목록을 표시할 ListView 위젯
  Widget _buildAnnouncementList() {
    // 현재 페이지에 해당하는 공지사항들을 리스트로 추출, 한 페이지에 5개씩 보여 줌
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