import 'package:flutter/material.dart';

class StudentRankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('월간 랭킹'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '명예의 전당',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  RankingTile(rank: 1, name: '학생 이름 1', score: 59230, icon: Icons.star),
                  RankingTile(rank: 2, name: '학생 이름 2', score: 55390, icon: Icons.star_half),
                  RankingTile(rank: 3, name: '학생 이름 3', score: 48900, icon: Icons.star_border),
                  RankingTile(rank: 4, name: '학생 이름 4', score: 47040, icon: Icons.star_border),
                  RankingTile(rank: 5, name: '학생 이름 5', score: 45500, icon: Icons.star_border),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('200', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RankingTile extends StatelessWidget {
  final int rank;
  final String name;
  final int score;
  final IconData icon;

  RankingTile({required this.rank, required this.name, required this.score, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(name),
        trailing: Text(
          '$score',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Rank: $rank'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StudentRankingPage(),
  ));
}
