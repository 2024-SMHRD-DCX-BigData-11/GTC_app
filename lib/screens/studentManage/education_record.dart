import 'package:dalgeurak/data/question.dart';
import 'package:dalgeurak/data/question_history.dart';
import 'package:flutter/material.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dio/dio.dart' as di;

class EducationRecord extends StatefulWidget {
  const EducationRecord({Key? key}) : super(key: key);

  @override
  _EducationRecord createState() => _EducationRecord();
}

class _EducationRecord extends State<EducationRecord> {
  late Future<List<QuestionHistory>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchDataFromApi();
  }

  @override
  Widget build(BuildContext context) {
    // 화면의 너비를 가져옵니다.
    double screenWidth = MediaQuery.of(context).size.width;

    // 기본 폰트 크기를 설정합니다.
    double baseFontSize = 14.0;

    // 화면 너비에 따른 폰트 크기를 조절합니다.
    double responsiveFontSize = baseFontSize * (screenWidth / 600);

    if (responsiveFontSize > 14) {
      responsiveFontSize = 14;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 학습 기록'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // 뒤로가기 아이콘
          onPressed: () {
            Navigator.pop(context); // 이전 화면으로 돌아가기
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<QuestionHistory>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              List<QuestionHistory> questions = snapshot.data!;

              return ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  var question = questions[index];
                  if (question.accuracy == null || question.isCorrect == null) {
                    return Column();
                  }
                  return Column(
                    children: [
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 제출 시간 텍스트
                            Text(
                              "제출 시간 : ${question.solvedAt}",
                              style: TextStyle(
                                fontSize: responsiveFontSize * 0.9,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),

                            // 난이도와 학년 정보
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "난이도 : ${"★" * question.question.difficulty}${"☆" * (3 - question.question.difficulty)}",
                                  style: TextStyle(
                                    fontSize: responsiveFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "초5 > ${question.question.term}학기 > ${question.question.sector1} > ${question.question.sector2}",
                                  style: TextStyle(
                                    fontSize: responsiveFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Image.network(
                                  "$apiUrl/save/${question.question.name}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "정답 여부 : ${question.isCorrect! ? "정답" : "오답"}  |  유사도 : ${question.accuracy! * 100}%",
                                    style: TextStyle(
                                      fontSize: responsiveFontSize * 0.9,
                                      color: Colors.grey[600],
                                    ),
                                    softWrap: true, // 자동 개행을 허용
                                    overflow:
                                        TextOverflow.visible, // 텍스트 오버플로우시 표시
                                  ),
                                ),
                                Row(
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                        _showDialog(question, false);
                                      },
                                      child: const Text('나의 풀이'),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton(
                                      onPressed: () {
                                        _showDialog(question, true);
                                      },
                                      child: const Text('모범 답안'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return const Center(child: Text('No Data Available'));
            }
          },
        ),
      ),
    );
  }

  Future<List<QuestionHistory>> _fetchDataFromApi() async {
    try {
      di.Response response = await dio.post(
        "$apiUrl/question/history",
        options: di.Options(contentType: "application/json"),
      );

      List<dynamic> jsonList = response.data;
      List<QuestionHistory> questions =
          jsonList.map((json) => QuestionHistory.fromJson(json)).toList();

      return questions;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  void _showDialog(QuestionHistory q, bool isSampleAnswer) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // 둥근 모서리 적용
          ),
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min, // 세로 크기를 콘텐츠에 맞춤
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isSampleAnswer ? "모범 답안" : "나의 풀이",
                        style:
                            const TextStyle(color: Colors.blue), // 제목 텍스트 색상 설정
                      ),
                      const SizedBox(height: 16),
                      Image.network(
                        isSampleAnswer
                            ? "$apiUrl/sampleAnswer/${q.question.name}".replaceAll(".png", "_A.png")
                            : "$apiUrl/history/${q.uuid}_solve.jpeg",
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, bottom: 16),
                  // 오른쪽과 아래에 여백 추가
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // 다이얼로그 닫기
                      },
                      child: const Text('닫기'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
