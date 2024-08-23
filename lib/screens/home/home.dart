import 'package:dalgeurak/screens/studentManage/contact_teacher.dart';
import 'package:dalgeurak/screens/studentManage/student_education_record.dart';
import 'package:dalgeurak/screens/studentManage/student_meal_plan.dart';
import 'package:dalgeurak/screens/studentManage/student_ranking.dart';
import 'package:dalgeurak/screens/studentManage/student_schedule.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';  // 이미지 선택을 위한 패키지
import 'dart:io';  // File 사용을 위해 필요

import '../../controllers/meal_controller.dart';
import '../../controllers/user_controller.dart';
import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';
import 'package:dalgeurak/screens/studentManage/student_mileage_store.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late MealController mealController;
  late UserController userController;
  late double _height, _width;
  File? _profileImage;  // 선택된 프로필 이미지를 저장하기 위한 변수

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
                        GestureDetector(
                          onTap: _pickImage,  // 이미지 선택을 위해 탭 이벤트 추가
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : AssetImage('assets/images/default_profile_image.png') as ImageProvider,
                          ),
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
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              double buttonSize = (constraints.maxWidth - 64) / 3;

                              return GridView.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                shrinkWrap: true,
                                childAspectRatio: 1,
                                children: [
                                  _buildShortcutButton(
                                      "마일리지 상점",
                                      Colors.pinkAccent,
                                      Icons.shopping_cart,
                                      buttonSize,
                                          () => Get.to(StudentMileageStorePage())),
                                  _buildShortcutButton(
                                      "이번 주 랭킹",
                                      Colors.cyanAccent,
                                      Icons.bar_chart,
                                      buttonSize,
                                          () => Get.to(StudentRankingPage())),
                                  _buildShortcutButton(
                                      "교육 기록 보기",
                                      Colors.lightGreen,
                                      Icons.history,
                                      buttonSize,
                                          () => Get.to(StudentEducationRecordPage())),
                                  _buildShortcutButton(
                                      "이번 주 시간표 보기",
                                      Colors.lightBlue,
                                      Icons.calendar_today,
                                      buttonSize,
                                          () => Get.to(StudentSchedulePage())),
                                  _buildShortcutButton(
                                      "급식",
                                      Colors.orangeAccent,
                                      Icons.restaurant_menu,
                                      buttonSize,
                                          () => Get.to(StudentMealPlanPage())),
                                  _buildShortcutButton(
                                      "선생님께 문의하기",
                                      Colors.purpleAccent,
                                      Icons.contact_support,
                                      buttonSize,
                                          () => Get.to(ContactTeacherPage())),
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

  // 이미지 선택 메서드
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
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
      String title, Color color, IconData icon, double size, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
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
            Icon(icon, size: 30, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
