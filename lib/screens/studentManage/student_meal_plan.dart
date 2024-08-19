import 'package:flutter/material.dart';

class StudentMealPlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('이번주 급식표')),
      body: Center(
        child: Text('여기에서 급식표 데이터를 보여줍니다.'),
      ),
    );
  }
}
