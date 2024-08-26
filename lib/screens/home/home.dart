import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../../controllers/meal_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:dalgeurak/screens/studentManage/contact_teacher.dart';
import 'package:dalgeurak/screens/studentManage/student_education_record.dart';
import 'package:dalgeurak/screens/studentManage/student_meal_plan.dart';
import 'package:dalgeurak/screens/studentManage/student_ranking.dart';
import 'package:dalgeurak/screens/studentManage/student_schedule.dart';
import 'package:dalgeurak/screens/studentManage/student_mileage_store.dart';
import 'web_functions.dart' if (dart.library.io) 'mobile_functions.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late MealController mealController;
  late UserController userController;
  late double _height, _width;
  File? _profileImage;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    mealController = Get.find<MealController>();
    userController = Get.find<UserController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/4f8a60aef14cc733ca0e8fc7e76c1738.png'),
            // 배경 이미지 설정
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SafeArea(
            child: Column(
              children: [
                _buildTopSection(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        _buildTimetableSection(),
                        const SizedBox(width: 16),
                        _buildShortcutSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      color: Colors.white.withOpacity(0.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _showBottomSheet,
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: userController.user?.imageUrl == null
                      ? const AssetImage(
                              "assets/images/default_profile_image.png")
                          as ImageProvider
                      : NetworkImage((userController.user?.imageUrl)!),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "${userController.user?.name}님 환영합니다",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
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
                "담당 선생님: 정진용",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimetableSection() {
    return Expanded(
      flex: 3,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.blue[50]!.withOpacity(0.8),
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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildTimetableItem("1교시: 수학", Icons.calculate),
                  _buildTimetableItem("2교시: 영어", Icons.language),
                  _buildTimetableItem("3교시: 과학", Icons.science),
                  _buildTimetableItem("4교시: 체육", Icons.sports_soccer),
                  _buildTimetableItem("5교시: 국어", Icons.book),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "150점", // 하드코딩된 마일리지 값
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutSection() {
    return Expanded(
      flex: 7,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
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
                _buildShortcutButton("마일리지 상점", 'assets/home/shop.png',
                    buttonSize, () => Get.to(StudentMileageStorePage())),
                _buildShortcutButton("이번 주 랭킹", 'assets/home/rank.png',
                    buttonSize, () => Get.to(StudentRankingPage())),
                _buildShortcutButton("교육 기록 보기", 'assets/home/record.png',
                    buttonSize, () => Get.to(StudentEducationRecordPage())),
                _buildShortcutButton("이번 주 시간표 보기", 'assets/home/timetable.png',
                    buttonSize, () => Get.to(StudentSchedulePage())),
                _buildShortcutButton("급식", 'assets/home/meal.png', buttonSize,
                    () => Get.to(StudentMealPlanPage())),
                _buildShortcutButton("선생님께 문의하기", 'assets/home/inquiry.png',
                    buttonSize, () => Get.to(ContactTeacherPage())),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimetableItem(String subject, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
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
            Icon(icon, size: 28, color: Colors.black54),
            const SizedBox(width: 8),
            Text(
              subject,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcutButton(
      String title, String iconPath, double size, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
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
            Image.asset(iconPath, height: 40, width: 40), // 이미지 크기를 키움
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14, // 글씨 크기를 키움
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadProfileImage() async {
    // Firestore에서 저장된 프로필 이미지 URL을 불러옵니다.
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userController.user?.userId)
        .get();
    setState(() {
      userController.user?.imageUrl = snapshot['profileImageUrl'];
    });
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCameraImage,
              child: const Text('사진 찍기'),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 3),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _getPhotoLibraryImage,
              child: const Text('갤러리에서 선택'),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 3),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _resetToDefaultImage, // 기본 이미지로 되돌리는 버튼
              child: const Text('기본 이미지로 설정'),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Future<void> _getCameraImage() async {
    if (kIsWeb) {
      userController.showToast("PC 환경에서는 사용할 수 없는 기능입니다.");
      return;
    }
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      await uploadImageA(pickedFile.path, (userController.user?.userId)!);
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
    await loadProfileImage();
    Navigator.of(context).pop(); // BottomSheet 닫기
  }

  Future<void> _getPhotoLibraryImage() async {
    getPhotoLibraryImage((userController.user?.userId)!);
    await loadProfileImage();
    Navigator.of(context).pop(); // BottomSheet 닫기
  }

  Future<void> _resetToDefaultImage() async {
    // 기본 이미지로 설정 (Firestore에서 이미지 URL 제거)
    await FirebaseFirestore.instance
        .collection('users')
        .doc((userController.user?.userId)!)
        .update({
      'profileImageUrl': FieldValue.delete(),
    });

    // 기본 상태로 설정
    setState(() {
      userController.user?.imageUrl = null;
    });

    Navigator.of(context).pop(); // BottomSheet 닫기
  }
}
