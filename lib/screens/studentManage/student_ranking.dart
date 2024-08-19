import 'package:flutter/material.dart';

class StudentRankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 임시 랭킹 데이터를 하드코딩
    final List<Map<String, dynamic>> rankings = [
      {"name": "건열", "score": 3870},
      {"name": "범훈", "score": 2540},
      {"name": "용민", "score": 2060},
      {"name": "현국", "score": 1990},
      {"name": "지은", "score": 1570},
      {"name": "성현", "score": 1120},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: Colors.lightBlue, // 앱바 배경색
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue[100]!, Colors.blue[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'LEADERBOARD',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Colors.blue[200]!,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: rankings.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.lightBlueAccent, Colors.blueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.yellowAccent,
                        radius: 28,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        rankings[index]['name'] ?? "Unknown",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.yellowAccent,
                            size: 24,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "${rankings[index]['score']}",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.yellowAccent,
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
                  icon: Icon(Icons.home, color: Colors.lightBlue[600], size: 40),
                  onPressed: () {},
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.play_circle_fill, color: Colors.lightBlue[600], size: 40),
                  onPressed: () {},
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.settings, color: Colors.lightBlue[600], size: 40),
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
