import 'package:flutter/material.dart';
import 'announcement.dart';
import 'contact.dart';
import 'login.dart';
import 'notificationsettings.dart';
import 'programinfo.dart';

class MorePage extends StatelessWidget {
  // 더보기 화면
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '더보기',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Divider(), // 행을 구분하기 위해 넣음
          _buildListItem(
              Icons.campaign, '공지사항', () => _navigateToAnnouncementPage(context)),
          Divider(),
          _buildListItem(Icons.notifications, '알림 설정',
                  () => _navigateToNotificationSettingsPage(context)),
          Divider(),
          _buildListItem(
              Icons.info, '프로그램 정보', () => _navigateToProgramInfoPage(context)),
          Divider(),
          _buildListItem(Icons.mail, '문의하기', () => _navigateToContactPage(context)),
          Divider(),
          _buildListItem(Icons.logout, '로그아웃', () => _logout(context)),
          Divider(),
        ],
      ),
    );
  }

  // 각 행을 클릭하면 수행되는 함수들
  void _navigateToAnnouncementPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AnnouncementPage()));
  }

  void _navigateToNotificationSettingsPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotificationSettingsPage()));
  }

  void _navigateToProgramInfoPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProgramInfoPage()));
  }

  void _navigateToContactPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ContactPage()));
  }

  void _logout(BuildContext context) {
    // 로그인 페이지로 이동하고 이전 경로들을 모두 제거
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false);
  }

  // 각 행을 만들어 줌
  Widget _buildListItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}


