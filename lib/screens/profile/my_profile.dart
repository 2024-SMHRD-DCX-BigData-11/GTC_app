import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/dialogs/class_dialog.dart';
import 'package:dalgeurak/dialogs/class_manage_dialog.dart';
import 'package:dalgeurak/screens/profile/myprofile_bottomsheet.dart';
import 'package:dalgeurak/screens/studentManage/education_record.dart';
import 'package:dalgeurak/screens/studentManage/application_status.dart';
import 'package:dalgeurak/screens/friend/friend_dialog.dart';
import 'package:dalgeurak/screens/studentManage/student_manage_dialog.dart';
import 'package:dalgeurak/screens/studentManage/student_schedule.dart';
import 'package:dalgeurak/screens/studentManage/student_mileage_store.dart';
import 'package:dalgeurak/services/remote_config.dart';
import 'package:dalgeurak/utils/toast.dart';
import 'package:dalgeurak_widget_package/widgets/dialog.dart';
import 'package:dalgeurak_widget_package/widgets/window_title.dart';
import 'package:dalgeurak/screens/widgets/medium_menu_button.dart';
import 'package:dalgeurak/screens/widgets/simple_list_button.dart';
import 'package:dalgeurak/themes/color_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dio/dio.dart' as di;

class MyProfile extends GetWidget<UserController> {
  MyProfile({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    final AuthController authController = Get.find<AuthController>();

    final MyProfileBottomSheet myProfileBottomSheet = MyProfileBottomSheet();
    final DalgeurakDialog dalgeurakDialog = DalgeurakDialog();
    final StudentManageDialog studentManageDialog = StudentManageDialog();
    ClassDialog classDialog = ClassDialog();

    controller.getUserWarningList();

    return Scaffold(
      backgroundColor: dalgeurakGrayOne,
      body: Center(
          child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(width: Get.width, height: 140),
                  Positioned(
                    top: _height * 0.05,
                    left: _width * 0.1,
                    child: Obx(() {
                      return WindowTitle(
                        subTitle: controller.user?.userType !=
                                DimigoinUserType.teacher
                            ? controller.user?.classId != null
                                ? "5학년"
                                : "반에 가입해주세요."
                            : "선생님",
                        title: (controller.user?.name)!,
                      );
                    }),
                  ),
                  Positioned(
                    right: -(_width * 0.125),
                    child: Image.asset(
                      "assets/images/home_flowerpot.png",
                      height: 124,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: _width * 0.897,
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Center(
                      child: SizedBox(
                        width: _width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("알림 허용", style: myProfileAlert),
                            FutureBuilder(
                                future: controller.checkUserAllowAlert(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return Obx(() => FlutterSwitch(
                                          height: 20,
                                          width: 41,
                                          padding: 3.0,
                                          toggleSize: 14,
                                          borderRadius: 21,
                                          activeColor: dalgeurakBlueOne,
                                          value: controller.isAllowAlert.value,
                                          onToggle: (value) => controller
                                              .setUserAllowAlert(value),
                                        ));
                                  } else if (snapshot.hasError) {
                                    //데이터를 정상적으로 불러오지 못했을 때
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                            width: _width,
                                            height: _height * 0.4),
                                        const Center(
                                            child: Text(
                                                "데이터를 정상적으로 불러오지 못했습니다. \n다시 시도해 주세요.",
                                                textAlign: TextAlign.center)),
                                      ],
                                    );
                                  } else {
                                    //데이터를 불러오는 중
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                            width: _width * 0.1,
                                            height: _height * 0.03),
                                        const Center(
                                            child: CircularProgressIndicator()),
                                      ],
                                    );
                                  }
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: _width * 0.897,
                    height: 240,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Center(
                        child: SizedBox(
                      width: _width * 0.68,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MediumMenuButton(
                                  iconName: "noticeCircle",
                                  title: "프로필 수정",
                                  subTitle: "개인 정보 변경",
                                  clickAction: () => studentManageDialog
                                      .showProfileEditDialog(controller),
                                ),
                                MediumMenuButton(
                                  iconName: "foodBucket",
                                  title: "이번주 시간표",
                                  subTitle: "확인하기",
                                  clickAction: () => {
                                    if (controller.user?.classId != null)
                                      {
                                        Get.to(StudentSchedulePage()),
                                      }
                                    else
                                      {
                                        showToast("반에 가입한 후 사용할 수 있는 기능입니다."),
                                      }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() {
                                  if (controller.user?.classId != null) {
                                    return MediumMenuButton(
                                      iconName: "class",
                                      title: "반 구성",
                                      subTitle: "조회",
                                      clickAction: () {
                                        _handleClassManageDialog();
                                      },
                                    );
                                  } else {
                                    return MediumMenuButton(
                                      iconName: "class",
                                      title: "반 설정",
                                      subTitle: "생성 / 가입",
                                      clickAction: () {
                                        classDialog.showDialog();
                                        // Get.to(QrCodeScan());
                                      },
                                    );
                                  }
                                }),
                                MediumMenuButton(
                                  iconName: "signDocu",
                                  title: "마일리지 상점",
                                  subTitle: "이용하기",
                                  clickAction: () => {
                                    if (controller.user?.classId != null)
                                      {
                                        Get.to(const StudentMileageStorePage()),
                                      }
                                    else
                                      {
                                        showToast("반에 가입한 후 사용할 수 있는 기능입니다."),
                                      }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MediumMenuButton(
                                  iconName: "twoTicket",
                                  title: "친구 관리",
                                  subTitle: "추가 / 삭제",
                                  clickAction: () => Get.to(const FriendPage()),
                                ),
                                MediumMenuButton(
                                  iconName: "cancel",
                                  title: "교육 기록 보기",
                                  subTitle: "조회하기",
                                  clickAction: () => {
                                    if (controller.user?.classId != null)
                                      {
                                        Get.to(const EducationRecord()),
                                      }
                                    else
                                      {
                                        showToast("반에 가입한 후 사용할 수 있는 기능입니다."),
                                      }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
                  ),
                  Container(
                      width: _width * 0.897,
                      height: (
                              // getTeacherMenu().length +
                              getStudentMenu().length + 5) *
                          50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ...getTeacherMenu(),
                          SimpleListButton(
                              title: "스마트인재개발원",
                              iconName: "page",
                              clickAction: () => _launchURL(
                                  Get.find<RemoteConfigService>()
                                      .getDienenManualFileUrl())),
                          SimpleListButton(
                              title: "문의하기",
                              iconName: "headset",
                              clickAction: () => dalgeurakDialog.showInquiry()),
                          SimpleListButton(
                              title: "인스타그램",
                              iconName: "instagram",
                              clickAction: () => _launchURL(
                                  "https://www.instagram.com/yanggeonyeol/")),
                          SimpleListButton(
                              title: "앱 정보",
                              iconName: "info",
                              clickAction: () =>
                                  myProfileBottomSheet.showApplicationInfo()),
                          SimpleListButton(
                              title: "로그아웃",
                              iconName: "logout",
                              color: Colors.red,
                              clickAction: () => authController.logOut()),
                        ],
                      )),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  // List<Widget> getTeacherMenu() {
  //   if (controller.user?.userType! == DimigoinUserType.teacher) {
  //     return [
  //       SimpleListButton(
  //           title: "차주 간편식, 선후밥 신청 현황",
  //           iconName: "foodBucket",
  //           clickAction: () => Get.to(ApplicationStatus())),
  //       SimpleListButton(
  //           title: "학생 식사 여부 통계",
  //           iconName: "graph",
  //           clickAction: () => print("onClick")),
  //       SimpleListButton(
  //           title: "학생 신청 금지 설정",
  //           iconName: "setting",
  //           clickAction: () => showSearch(
  //               context: Get.context!, delegate: ApplicationBlackList())),
  //       SimpleListButton(
  //           title: "학생 급식비 납부금",
  //           iconName: "coin",
  //           clickAction: () => print("onClick")),
  //     ];
  //   } else {
  //     return [];
  //   }
  // }

  List<Widget> getStudentMenu() {
    if (controller.user?.userType! == DimigoinUserType.student) {
      return [
        SimpleListButton(
            title: "간편식, 선후밥 신청 현황",
            iconName: "signDocu",
            clickAction: () => Get.to(ApplicationStatus())),
      ];
    } else {
      return [];
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _handleClassManageDialog() async {
    bool isSuccess = await check(); // 비동기 작업이 완료될 때까지 기다림
    if (isSuccess) {
      Get.dialog(const ClassManageDialog());
    } else {
      controller.updateInfo();
    }
  }

  Future<bool> check() async {
    di.Response response = await dio.post(
      "$apiUrl/class/check",
      options: di.Options(contentType: "application/json"),
    );
    return response.data["success"];
  }
}
