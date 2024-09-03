import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dalgeurak/screens/studentManage/education_record.dart';
import 'package:dalgeurak/utils/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../controllers/meal_controller.dart';
import '../../controllers/user_controller.dart';
import 'package:dalgeurak/screens/studentManage/contact_teacher.dart';
import 'package:dalgeurak/screens/studentManage/student_meal_plan.dart';
import 'package:dalgeurak/screens/studentManage/student_ranking.dart';
import 'package:dalgeurak/screens/studentManage/student_schedule.dart';
import 'package:dalgeurak/screens/studentManage/student_mileage_store.dart';
import 'web_functions.dart' if (dart.library.io) 'mobile_functions.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dio/dio.dart' as di;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MealController mealController = Get.find<MealController>();
  final UserController userController = Get.find<UserController>();
  late double _height, _width;

  @override
  void initState() {
    super.initState();
    loadProfileImage(); // 프로필 불러오기
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

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
              Obx(() {
                return GestureDetector(
                  onTap: _showBottomSheet,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: userController.user?.imageUrl == null
                        ? const AssetImage("assets/images/default_profile_image.png")
                    as ImageProvider
                        : NetworkImage((userController.user?.imageUrl)!),
                  ),
                );
              }),
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
              children: [
                const Text(
                  "현재 마일리지",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "${userController.user?.mileage}점",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
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
                  () => {
                        if (userController.user?.classId != null)
                          {
                            Get.to(const StudentMileageStorePage()),
                          }
                        else
                          {
                            showToast("반에 가입한 후 사용할 수 있는 기능입니다."),
                          },
                      }),
              _buildShortcutButton(
                "이번 주 랭킹",
                'assets/home/rank.png',
                buttonWidth,
                buttonHeight,
                Colors.cyanAccent,
                () => {
                  if (userController.user?.classId != null)
                    {
                      Get.to(const StudentRankingPage()),
                    }
                  else
                    {
                      showToast("반에 가입한 후 사용할 수 있는 기능입니다."),
                    }
                },
              ),
              _buildShortcutButton(
                "교육 기록 보기",
                'assets/home/record.png',
                buttonWidth,
                buttonHeight,
                Colors.greenAccent,
                () => {
                  if (userController.user?.classId != null)
                    {
                      Get.to(const EducationRecord()),
                    }
                  else
                    {
                      showToast("반에 가입한 후 사용할 수 있는 기능입니다."),
                    }
                },
              ),
              _buildShortcutButton(
                  "이번 주 시간표 보기",
                  'assets/home/timetable.png',
                  buttonWidth,
                  buttonHeight,
                  Colors.blueAccent,
                  () => {
                    if (userController.user?.classId != null)
                      {
                        Get.to(StudentSchedulePage()),
                      }
                    else
                      {
                        showToast("반에 가입한 후 사용할 수 있는 기능입니다."),
                      }
                  },
              ),
              _buildShortcutButton(
                  "식단표",
                  'assets/home/meal.png',
                  buttonWidth,
                  buttonHeight,
                  Colors.orangeAccent,
                  () => {
                    if (userController.user?.classId != null)
                      {
                        Get.to(StudentMealPlanPage()),
                      }
                    else
                      {
                        showToast("반에 가입한 후 사용할 수 있는 기능입니다."),
                      }
                  },
              ),
              _buildShortcutButton(
                  "선생님께 문의하기",
                  'assets/home/inquiry.png',
                  buttonWidth,
                  buttonHeight,
                  Colors.purpleAccent,
                  () => {
                    if (userController.user?.classId != null)
                      {
                        Get.to(ContactTeacherPage()),
                      }
                    else
                      {
                        showToast("반에 가입한 후 사용할 수 있는 기능입니다."),
                      }
                  },
              ),
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
      userController.user?.setImageUrl = snapshot['profileImageUrl'];
      print("userController.user?.imageUrl : ${userController.user?.imageUrl}");
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
      userController.showToast("웹 환경에서는 사용할 수 없는 기능입니다.");
      return;
    }
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      await uploadImageA(pickedFile.path);
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
    await loadProfileImage();
    Navigator.of(context).pop(); // BottomSheet 닫기
  }

  Future<void> _getPhotoLibraryImage() async {
    await getPhotoLibraryImage(() async {
      await Future.delayed(const Duration(milliseconds: 500)); // 10초 딜레이
      userController.updateInfo();
      Navigator.of(context).pop(); // BottomSheet 닫기
    });
  }


  Future<void> _resetToDefaultImage() async {
    di.Response response = await dio.post(
      "$apiUrl/profile/reset",
      options: di.Options(contentType: "application/json"),
    );

    setState(() {
      userController.user?.setImageUrl = null;
    });

    Navigator.of(context).pop(); // BottomSheet 닫기
  }
}
