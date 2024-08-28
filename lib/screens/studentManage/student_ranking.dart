import 'package:flutter/material.dart';
import 'friend_dialog.dart';

class StudentRankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> rankings = [
      {"name": "건열", "isFriend": true},
      {"name": "범훈", "isFriend": false},
      {"name": "용민", "isFriend": true},
      {"name": "현국", "isFriend": false},
      {"name": "지은", "isFriend": true},
      {"name": "성현", "isFriend": false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: Colors.lightBlue,
      ),
      body: ListView.builder(
        itemCount: rankings.length,
        itemBuilder: (context, index) {
          final String name = rankings[index]['name'];
          final bool isFriend = rankings[index]['isFriend'];

          return ListTile(
            leading: Icon(
              isFriend ? Icons.person_remove : Icons.person_add,
              color: isFriend ? Colors.redAccent : Colors.green,
            ),
            title: Text(name),
            subtitle: Text(isFriend ? "친구 삭제" : "친구 추가"),
            onTap: () {
              // 친구 추가/삭제 다이얼로그 표시
              FriendDialog(
                name: name,
                isFriend: isFriend,
                onAction: () {
                  // 여기에 친구 추가/삭제 로직 구현
                  print("$name 친구 상태 변경");
                },
              ).showDialog();
            },
          );
        },
      ),
    );
  }
}
