import 'package:flutter/material.dart';

class StudentSchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('이번주 시간표')),
      body: Center(
        child: Text('여기에서 시간표 데이터를 보여줍니다.'),
      ),
    );
  }
}
