import 'dart:math';
import 'package:flutter/material.dart';

class StudentMealPlanPage extends StatefulWidget {
  @override
  _StudentMealPlanPageState createState() => _StudentMealPlanPageState();
}

class _StudentMealPlanPageState extends State<StudentMealPlanPage> {
  int _currentMonth = DateTime.now().month;
  late List<List<String>> mealPlans;

  @override
  void initState() {
    super.initState();
    _generateMealPlans();
  }

  // 급식 데이터를 생성하는 메서드
  void _generateMealPlans() {
    final random = Random();
    mealPlans = List.generate(12, (month) {
      return List.generate(5, (index) {
        final menu = [
          "김밥, 된장국, 계란말이",
          "비빔밥, 미역국, 불고기",
          "돈까스, 샐러드, 스프",
          "짜장면, 탕수육, 단무지",
          "카레라이스, 샐러드, 요구르트",
          "삼겹살, 상추쌈, 된장찌개",
          "초밥, 우동, 샐러드",
          "제육볶음, 김치찌개, 콩나물",
          "떡볶이, 순대, 오뎅국",
          "닭볶음탕, 두부조림, 쌈채소"
        ];
        return "${_getDayOfWeek(index)}: ${menu[random.nextInt(menu.length)]}";
      });
    });
  }

  // 요일을 반환하는 메서드
  String _getDayOfWeek(int index) {
    const days = ["월요일", "화요일", "수요일", "목요일", "금요일"];
    return days[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_currentMonth}월 급식표'),
        actions: [
          PopupMenuButton<int>(
            onSelected: (month) {
              setState(() {
                _currentMonth = month;
              });
            },
            itemBuilder: (context) => List.generate(12, (index) {
              return PopupMenuItem(
                value: index + 1,
                child: Text('${index + 1}월'),
              );
            }),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '${_currentMonth}월 급식표',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: mealPlans[_currentMonth - 1].length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        mealPlans[_currentMonth - 1][index],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
