import 'package:flutter/material.dart';

class StudentRankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 임시 랭킹 데이터를 하드코딩
    final List<Map<String, dynamic>> rankings = [
      {"name": "Kevin", "score": 3870000},
      {"name": "Abraham", "score": 2540000},
      {"name": "James", "score": 2060000},
      {"name": "Sarah", "score": 1970000},
      {"name": "John", "score": 1970000},
      {"name": "Emily", "score": 1970000},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: Container(
        color: Colors.grey[100], // 배경색을 밝은 회색으로 설정
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'LEADERBOARD',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: rankings.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        rankings[index]['name'] ?? "Unknown",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: Colors.yellow,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "${rankings[index]['score']}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // 하단의 아이콘 버튼들
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.purple, size: 40),
                  onPressed: () {},
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.play_circle_filled, color: Colors.purple, size: 40),
                  onPressed: () {},
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.settings, color: Colors.purple, size: 40),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
