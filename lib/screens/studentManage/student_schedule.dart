import 'package:flutter/material.dart';

class StudentSchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 임시 시간표 데이터를 하드코딩
    final schedule = [
      ["수학", "국어", "창체", "국어", "국어"],
      ["국어", "안전", "통합", "통합", "수학"],
      ["통합", "창체", "통합", "수학", "통합"],
      ["통합", "수학", "국어", "수학", "통합"],
    ];

    final days = ["월요일", "화요일", "수요일", "목요일", "금요일"];

    return Scaffold(
      appBar: AppBar(
        title: Text('이번 주 시간표'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '1학기 시간표',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Table(
                border: TableBorder.all(color: Colors.black),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.green[200]),
                    children: [
                      Container(), // 빈 칸 (교시 번호)
                      for (var day in days)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            day,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  for (int i = 0; i < schedule.length; i++)
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${i + 1}교시",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        for (int j = 0; j < schedule[i].length; j++)
                          Container(
                            height: 50,
                            color: Colors.green[50],
                            child: Center(
                              child: Text(
                                schedule[i][j],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  // 점심시간 추가
                  TableRow(
                    decoration: BoxDecoration(color: Colors.orange[100]),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "점심시간",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      for (var i = 0; i < 5; i++)
                        Container(
                          height: 50,
                          color: Colors.yellow[100],
                          child: Center(
                            child: Text(
                              "즐거운 점심시간",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  // 5교시
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "5교시",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      for (int j = 0; j < schedule[0].length; j++)
                        Container(
                          height: 50,
                          color: Colors.green[50],
                          child: Center(
                            child: Text(
                              schedule[3][j],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
