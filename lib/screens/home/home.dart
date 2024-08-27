import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

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
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late MealController mealController;
  late UserController userController;
  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    mealController = Get.find<MealController>();
    userController = Get.find<UserController>();

    loadProfileImage(); // 프로필 불러오기

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SafeArea(
          child: Column(
            children: [
              _buildTopSection(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      bool isWide = constraints.maxWidth > 600;
                      return isWide
                          ? Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: _buildTimetableSection(),
                                ),
                                const SizedBox(width: 16), // 간격 추가
                                Expanded(
                                  flex: 7,
                                  child: _buildShortcutSection(),
                                ),
                              ],
                            )
                          : Column(
                              children: <Widget>[
                                Expanded(
                                  child: _buildTimetableSection(),
                                ),
                                const SizedBox(height: 16), // 간격 추가
                                Expanded(
                                  child: _buildShortcutSection(),
                                ),
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
    );
  }

  Widget _buildTopSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      color: Colors.white.withOpacity(0.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/logo2.png',
            height: 150,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "오늘은 ${DateFormat('MM월 dd일 EEEE', 'ko_KR').format(DateTime.now())}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "오늘의 할 일 ${3}개입니다",
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              const Text(
                "담당 선생님: 정진용",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
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
        ],
      ),
    );
  }

  Widget _buildTimetableSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[50]!.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
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
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "현재 마일리지",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "150점",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double buttonWidth = (constraints.maxWidth - 48) / 3;
          double buttonHeight = (constraints.maxHeight - 32) / 2;

          return GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: buttonWidth / buttonHeight,
            shrinkWrap: true,
            children: [
              _buildShortcutButton(
                  "마일리지 상점",
                  'assets/home/shop.png',
                  buttonWidth,
                  buttonHeight,
                  Colors.pinkAccent,
                  () => Get.to(const StudentMileageStorePage())),
              _buildShortcutButton(
                  "이번 주 랭킹",
                  'assets/home/rank.png',
                  buttonWidth,
                  buttonHeight,
                  Colors.cyanAccent,
                  () => Get.to(StudentRankingPage())),
              _buildShortcutButton(
                  "교육 기록 보기",
                  'assets/home/record.png',
                  buttonWidth,
                  buttonHeight,
                  Colors.greenAccent,
                  () => Get.to(StudentEducationRecordPage())),
              _buildShortcutButton(
                  "이번 주 시간표 보기",
                  'assets/home/timetable.png',
                  buttonWidth,
                  buttonHeight,
                  Colors.blueAccent,
                  () => Get.to(StudentSchedulePage())),
              _buildShortcutButton(
                  "식단표",
                  'assets/home/meal.png',
                  buttonWidth,
                  buttonHeight,
                  Colors.orangeAccent,
                  () => Get.to(StudentMealPlanPage())),
              _buildShortcutButton(
                  "선생님께 문의하기",
                  'assets/home/inquiry.png',
                  buttonWidth,
                  buttonHeight,
                  Colors.purpleAccent,
                  () => Get.to(ContactTeacherPage())),
            ],
          );
        },
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
          boxShadow: const [
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
              style: const TextStyle(
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

  Widget _buildShortcutButton(String title, String iconPath, double width,
      double height, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: width,
              height: height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Image.asset(iconPath, height: height * 0.4),
              ),
            ),
            Container(
              width: width,
              height: height * 0.3,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadProfileImage() async {
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
              onPressed: _resetToDefaultImage,
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
    await FirebaseFirestore.instance
        .collection('users')
        .doc((userController.user?.userId)!)
        .update({
      'profileImageUrl': FieldValue.delete(),
    });

    setState(() {
      userController.user?.imageUrl = null;
    });

    Navigator.of(context).pop(); // BottomSheet 닫기
  }
}
