import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EducationRecord(),
    );
  }
}

class EducationRecord extends StatelessWidget {
  final List<Map<String, dynamic>> records = [
    {
      'problemImage': 'assets/images/logo.png',
      'answerImage': 'assets/images/logo2.png',
      'accuracy': 90,
      'isCorrect': true
    },
    {
      'problemImage': 'assets/images/logo2.png',
      'answerImage': 'assets/images/logo.png',
      'accuracy': 75,
      'isCorrect': false
    },
    {
      'problemImage': 'assets/images/logo2.png',
      'answerImage': 'assets/images/logo2.png',
      'accuracy': 85,
      'isCorrect': true
    },
    {
      'problemImage': 'assets/images/logo.png',
      'answerImage': 'assets/images/logo.png',
      'accuracy': 60,
      'isCorrect': false
    },
    {
      'problemImage': 'assets/images/splashImageBranding.png',
      'answerImage': 'assets/images/splashImageBranding.png',
      'accuracy': 100,
      'isCorrect': true
    },
    {
      'problemImage': 'assets/images/splashImageBranding.png',
      'answerImage': 'assets/images/splashImageBranding.png',
      'accuracy': 10,
      'isCorrect': true
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('모범 답안'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // 뒤로가기 아이콘
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 돌아가기
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return Container(
              margin: EdgeInsets.only(bottom: 8.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.blue),
              ),
              child: Row(
                  children: [
                    // 왼쪽: 문제 이미지 및 정답 이미지
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center, // 이미지 가운데 정렬
                            child: Image.asset(
                              record['problemImage'],
                              height: 100, // 원하는 높이 설정
                              width: double.infinity, // 박스 크기에 맞춤
                              fit: BoxFit.contain, // 비율 유지하며 박스에 맞춤 (자르지 않음)
                            ),
                          ),
                          SizedBox(height: 8.0), // 문제 이미지와 정답 이미지 간격
                          Container(
                            alignment: Alignment.center, // 이미지 가운데 정렬
                            child: Image.asset(
                              record['answerImage'],
                              height: 100, // 원하는 높이 설정
                              width: double.infinity, // 박스 크기에 맞춤
                              fit: BoxFit.contain, // 비율 유지하며 박스에 맞춤 (자르지 않음)
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0), // 왼쪽과 오른쪽 간격 추가
                    // 오른쪽: 정확도 및 정답 여부
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '정확도: ${record['accuracy']}%',
                            style: TextStyle(fontSize: 26, color: Colors.blue[800]),
                          ),
                          SizedBox(height: 60.0), // 정확도와 정답 여부 간격 추가
                          Text(
                            '정답 여부: ${record['isCorrect'] ? '정답' : '오답'}',
                            style: TextStyle(fontSize: 26, color: Colors.blue[800]),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(width: 16.0), // 왼쪽과 오른쪽 간격 추가
                    // 오른쪽: 정확도 및 정답 여부
                    Expanded(
                      child: Column(

                        children: [
                          SizedBox(height: 160.0),
                          Align(
                            alignment: Alignment.bottomRight, // 우측 하단 정렬
                            child: ElevatedButton(
                              onPressed: () {
                                // 해설 보기 버튼 클릭 시 동작
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        '쏙쏙풀이',
                                        style: TextStyle(color: Colors.blue), // 제목 텍스트 색상을 파란색으로 설정
                                      ),
                                      content: Container(
                                        height: 400,
                                        child: Image.asset(
                                          record['problemImage'], // 이미지 경로
                                          fit: BoxFit.cover, // 다이얼로그에 맞게 이미지 크기 조정
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(); // 다이얼로그 닫기
                                          },
                                          child: Text('닫기'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                '쏙쏙풀이',
                                style: TextStyle(fontSize: 18), // 폰트 크기 조정
                              ),
                            ),
                          ),

                        ],
                      ),
                    )
                  ]
              ),
            );
          },
        ),
      ),
    );
  }
}