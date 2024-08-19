import 'package:flutter/material.dart';

class StudentEducationRecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 임시 교육 기록 데이터를 하드코딩
    final educationRecords = [
      "1학기: 우수 학생상",
      "2학기: 과학 경시대회 1등",
      "1학기: 영어 말하기 대회 참가",
      "2학기: 수학 올림피아드 은상"
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('교육 기록 보기'),
      ),
      body: ListView.builder(
        itemCount: educationRecords.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(educationRecords[index]),
          );
        },
      ),
    );
  }
}
