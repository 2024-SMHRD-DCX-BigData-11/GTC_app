import 'package:flutter/material.dart';

class StudentMileageStorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('마일리지 상점')),
      body: Center(
        child: Text('여기에서 마일리지로 구매할 수 있는 아이템들을 보여줍니다.'),
      ),
    );
  }
}
