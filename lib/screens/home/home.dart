import 'package:dalgeurak/screens/home/home_bottomsheet.dart';
import 'package:dalgeurak/screens/home/register_notice.dart';
import 'package:dalgeurak/screens/home/widgets/live_meal_sequence.dart';
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // 상단 섹션
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "오늘은 ${DateFormat('MM월 dd일 EEEE', 'ko_KR').format(DateTime.now())} 입니다",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "오늘의 할 일 ${3}개가 있어요.",
                            style: TextStyle(fontSize: 18, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "담당 선생님: 조용준",
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/profile_image.png'), // 학생 프로필 이미지
                      ),
                    ],
                  ),
                ),

                // 중앙 섹션
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      // 왼쪽의 오늘 시간표 공간
                      Container(
                        width: _width * 0.3,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(0), // 모서리를 없앰
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
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            // 시간표 내용이 많지 않으므로 Expanded를 제거합니다.
                            ListView(
                              shrinkWrap: true, // 리스트뷰의 높이를 내용에 맞게 조절
                              physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
                              children: [
                                // 예시 시간표 항목들
                                Text("1교시: 수학", style: TextStyle(fontSize: 16)),
                                Text("2교시: 영어", style: TextStyle(fontSize: 16)),
                                Text("3교시: 과학", style: TextStyle(fontSize: 16)),
                                Text("4교시: 체육", style: TextStyle(fontSize: 16)),
                                Text("5교시: 국어", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // 오른쪽의 바로가기 버튼들
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          shrinkWrap: true, // GridView의 높이를 내용에 맞게 조절
                          physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
                          children: [
                            _buildShortcutButton("마일리지 상점", Colors.pinkAccent),
                            _buildShortcutButton("교육 기록 보기", Colors.lightGreen),
                            _buildShortcutButton("이번 주 시간표 보기", Colors.lightBlue),
                            _buildShortcutButton("지난 교육 해설 보기", Colors.orangeAccent),
                            _buildShortcutButton("선생님께 문의하기", Colors.purpleAccent),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 하단 섹션
                Obx(() {
                  // 임시로 모든 사용자를 학생으로 간주
                  bool isStudent = true;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 350,
                        margin: EdgeInsets.only(bottom: Get.height * 0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 280,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("공지사항", style: homeMealSequenceTitle.copyWith(color: Colors.black)),
                                  SizedBox(), // 기능을 제거하므로 빈 위젯
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: 280,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Obx(() => Flexible(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      strutStyle: StrutStyle(fontSize: 16.0),
                                      text: TextSpan(
                                        text: mealController.noticeText.value,
                                        style: homeNotice,
                                      ),
                                    ),
                                  ))
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      (isStudent
                          ? _buildDienenMenuBtnWidget(context)
                          : _buildTeacherMenuBtnWidget(context)),
                      (isStudent
                          ? LiveMealSequence(mealSequenceMode: LiveMealSequenceMode.blue)
                          : Column(
                        children: [
                          LiveMealSequence(mealSequenceMode: LiveMealSequenceMode.white, checkGradeNum: 2),
                          LiveMealSequence(mealSequenceMode: LiveMealSequenceMode.blue, checkGradeNum: 1),
                        ],
                      )),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 추가된 _buildShortcutButton 메서드
  Widget _buildShortcutButton(String title, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8), // 모서리를 약간 둥글게 설정
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // _buildDienenMenuBtnWidget 메서드
  Widget _buildDienenMenuBtnWidget(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 350,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              "학생 편의식 관리",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: 350,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              "학생 식사예외 관리",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: 350,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.purpleAccent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              "식권 QR 스캔",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // _buildTeacherMenuBtnWidget 메서드
  Widget _buildTeacherMenuBtnWidget(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 350,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              "QR 코드로 검색",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: 350,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              "학생 검색",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: 350,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              "배식 취소",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: 350,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.tealAccent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              "급식 취소 확인",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
