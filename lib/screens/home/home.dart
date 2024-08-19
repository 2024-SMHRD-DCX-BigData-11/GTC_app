import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../controllers/meal_controller.dart';
import '../../controllers/user_controller.dart';
import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  late MealController mealController;
  late UserController userController;
  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    mealController = Get.find<MealController>();
    userController = Get.find<UserController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: dalgeurakGrayOne,
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              // 상단 섹션
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                              'assets/profile_image.png'), // 학생 프로필 이미지
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "${userController.user?.name}님 환영합니다",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "오늘은 ${DateFormat('MM월 dd일 EEEE', 'ko_KR').format(DateTime.now())} 입니다",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "오늘의 할 일 ${3}개가 있어요.",
                          style: TextStyle(fontSize: 18, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "담당 선생님: 정진용",
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 중앙 섹션
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // 왼쪽의 오늘 시간표 공간
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(16),
                            // 모서리를 둥글게 설정
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "오늘 시간표",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: ListView(
                                  children: [
                                    _buildTimetableItem(
                                        "1교시: 수학", Icons.calculate),
                                    _buildTimetableItem(
                                        "2교시: 영어", Icons.language),
                                    _buildTimetableItem(
                                        "3교시: 과학", Icons.science),
                                    _buildTimetableItem(
                                        "4교시: 체육", Icons.sports_soccer),
                                    _buildTimetableItem("5교시: 국어", Icons.book),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "현재 마일리지",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "150점", // 하드코딩된 마일리지 값
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // 오른쪽의 바로가기 버튼들
                      Expanded(
                        flex: 7,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // 배경색
                            borderRadius: BorderRadius.circular(16),
                            // 모서리를 둥글게 설정
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // 버튼 정사각형 유지
                              double buttonSize = (constraints.maxWidth - 64) /
                                  3; // 간격 조정 및 버튼 크기 축소

                              return GridView.count(
                                crossAxisCount: 3,
                                // 세로로 3개의 버튼을 배치하도록 설정
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                shrinkWrap: true,
                                childAspectRatio: 1,
                                // 정사각형 유지
                                children: [
                                  _buildShortcutButton(
                                      "마일리지 상점",
                                      Colors.pinkAccent,
                                      Icons.shopping_cart,
                                      buttonSize),
                                  _buildShortcutButton(
                                      "이번 주 랭킹",
                                      Colors.cyanAccent,
                                      Icons.bar_chart,
                                      buttonSize),
                                  _buildShortcutButton(
                                      "교육 기록 보기",
                                      Colors.lightGreen,
                                      Icons.history,
                                      buttonSize),
                                  _buildShortcutButton(
                                      "이번 주 시간표 보기",
                                      Colors.lightBlue,
                                      Icons.calendar_today,
                                      buttonSize),
                                  _buildShortcutButton(
                                      "지난 교육 해설 보기",
                                      Colors.orangeAccent,
                                      Icons.book,
                                      buttonSize),
                                  _buildShortcutButton(
                                      "선생님께 문의하기",
                                      Colors.purpleAccent,
                                      Icons.contact_support,
                                      buttonSize),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 시간표 항목 생성 메서드
  Widget _buildTimetableItem(String subject, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black54),
            const SizedBox(width: 8),
            Text(
              subject,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 버튼 생성 메서드
  Widget _buildShortcutButton(
      String title, Color color, IconData icon, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16), // 모서리를 둥글게 설정
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.white), // 아이콘 크기 축소
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12, // 폰트 크기 축소
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
