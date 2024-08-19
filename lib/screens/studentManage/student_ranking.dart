import 'package:flutter/material.dart';

class StudentRankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('이번 주 랭킹')),
      body: Center(
        child: Text('여기에서 학생들의 랭킹을 보여줍니다.'),
      ),
    );
  }
}
