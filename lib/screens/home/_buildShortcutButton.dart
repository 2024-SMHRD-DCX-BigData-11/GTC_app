import 'package:dalgeurak/screens/home/home_bottomsheet.dart';
import 'package:dalgeurak/screens/home/register_notice.dart';
import 'package:dalgeurak/screens/home/widgets/live_meal_sequence.dart';
import 'package:dalgeurak/screens/studentManage/convenience_food.dart';
import 'package:dalgeurak/screens/studentManage/meal_exception.dart';
import 'package:dalgeurak_meal_application/pages/teacher_meal_cancel/teacher_meal_cancel.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';  // DateFormat을 사용하기 위한 import

import 'package:dalgeurak_widget_package/widgets/window_title.dart';
import '../../controllers/meal_controller.dart';
import '../../controllers/qrcode_controller.dart';
import '../../controllers/user_controller.dart';
import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';
import '../studentManage/meal_cancel_confirm.dart';
import '../widgets/big_menu_button.dart';
import '../studentManage/student_search.dart';
import '../studentManage/qrcode_scan.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  late MealController mealController;
  late UserController userController;
  late QrCodeController qrCodeController;
  late HomeBottomSheet _homeBottomSheet;
  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    mealController = Get.find<MealController>();
    userController = Get.find<UserController>();
    qrCodeController = Get.find<QrCodeController>();
    _homeBottomSheet = HomeBottomSheet();

    if (!mealController.isCreateRefreshTimer) {
      mealController.refreshTimer();
      mealController.isCreateRefreshTimer = true;
    }

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
                            SizedBox(
                              height: _height * 0.3, // 높이 설정
                              child: ListView(
                                children: [
                                  // 예시 시간표 항목들
                                  Text("1교시: 수학", style: TextStyle(fontSize: 16)),
                                  Text("2교시: 영어", style: TextStyle(fontSize: 16)),
                                  Text("3교시: 과학", style: TextStyle(fontSize: 16)),
                                  Text("4교시: 체육", style: TextStyle(fontSize: 16)),
                                  Text("5교시: 국어", style: TextStyle(fontSize: 16)),
                                ],
                              ),
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
                          shrinkWrap: true, // 높이를 고정하지 않고 내용에 맞게 조절
                          physics: NeverScrollableScrollPhysics(), // ScrollView의 기본 스크롤 제어 유지
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
                  bool? isDienen = userController.user?.permissions?.contains(DimigoinPermissionType.dalgeurak); isDienen ??= false;
                  bool isStudent = userController.user?.userType != DimigoinUserType.teacher;

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
                                  (userController.user?.userType == DimigoinUserType.teacher ?
                                  GestureDetector(onTap: () => Get.to(RegisterNotice()), child: SvgPicture.asset("assets/images/icons/signDocu.svg", color: Colors.black, width: 20)) : SizedBox()),
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
                      // getDienenMenuBtnWidget 호출 제거
                      (isStudent ? SizedBox() : getTeacherMenuBtnWidget(context)),
                      (isStudent ?
                      LiveMealSequence(mealSequenceMode: LiveMealSequenceMode.blue)
                          : Column(
                          children: [
                            LiveMealSequence(mealSequenceMode: LiveMealSequenceMode.white, checkGradeNum: 2),
                            LiveMealSequence(mealSequenceMode: LiveMealSequenceMode.blue, checkGradeNum: 1),
                          ])),
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

  // _buildShortcutButton 메서드 추가
  Widget _buildShortcutButton(String title, Color color) {
    return GestureDetector(
      onTap: () {
        // 해당 버튼 클릭 시의 동작을 정의할 수 있습니다.
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(0), // 모서리를 없앰
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
