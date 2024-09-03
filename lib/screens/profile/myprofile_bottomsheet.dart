import 'package:dalgeurak_widget_package/widgets/bottom_sheet.dart';
import 'package:dalgeurak_widget_package/widgets/dialog.dart';
import 'package:dalgeurak_widget_package/widgets/overlay_alert.dart';
import 'package:dalgeurak_widget_package/widgets/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/meal_controller.dart';
import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';

class MyProfileBottomSheet {
  DalgeurakService _dalgeurakService = Get.find<DalgeurakService>();

  DalgeurakToast _dalgeurakToast = DalgeurakToast();
  DalgeurakBottomSheet _dalgeurakBottomSheet = DalgeurakBottomSheet();
  DalgeurakDialog _dalgeurakDialog = DalgeurakDialog();
  DalgeurakOverlayAlert _dalgeurakOverlayAlert = DalgeurakOverlayAlert(context: Get.context!);

  RxMap warningList = {
    "지각": false,
    "욕설": false,
    "통로 사용": false,
    "순서 무시": false,
    "기타": false,
  }.obs;
  TextEditingController warningReasonTextController = TextEditingController();
  MealController mealController = Get.find<MealController>();

  showApplicationInfo() => _dalgeurakBottomSheet.show(
      0.579,
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(width: Get.width, height: Get.height * 0.579),
          Positioned(
            top: Get.height * 0.04,
            left: Get.width * 0.06,
            child: Text("어플리케이션 정보", style: myProfile_appInfo_title),
          ),
          Positioned(
              top: Get.height * 0.09,
              child: Container(width: Get.width * 0.882, child: Divider(color: dalgeurakGrayOne, thickness: 1.0))
          ),
          Positioned(
              top: Get.height * 0.125,
              left: Get.width * 0.06,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logo2-removebg.png",
                    width: 70,
                    height: 70,
                  ),
                  SizedBox(width: 18),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("GTC_app", style: myProfile_appInfo_title),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Text("현재 설치 버전 : ", style: myProfile_appInfo_appVersion),
                          FutureBuilder(
                              future: _getAppVersion(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data, style: myProfile_appInfo_appVersion);
                                } else { //데이터를 불러오는 중
                                  return Center(child: CircularProgressIndicator());
                                }
                              }
                          )
                        ],
                      )
                    ],
                  )
                ],
              )
          ),
          Positioned(
            top: Get.height * 0.225,
            left: Get.width * 0.06,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "본 어플리케이션 ",
                    style: myProfile_appInfo_content,
                  ),
                  TextSpan(
                    text: "GTC",
                    style: myProfile_appInfo_content.copyWith(fontWeight: FontWeight.w600)
                  ),
                  const TextSpan(
                    text: "는\n스마트 인재 개발원 순천점의 A반 2조 팀 GTC\n"
                  ),
                  TextSpan(
                      text: "양건열 ",
                      style: myProfile_appInfo_content.copyWith(fontWeight: FontWeight.w600)
                  ),
                  const TextSpan(
                      text: "소속 팀원이 제작하였습니다.\n\n"
                  ),
                  const TextSpan(
                    text: "본 서비스를 로그인하여 사용하는 것은\n"
                  ),
                  TextSpan(
                    text: "개인정보처리약관",
                    style: myProfile_appInfo_content.copyWith(color: dalgeurakBlueOne, fontWeight: FontWeight.w600),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        String url = 'https://bit.ly/2XPgDq9';
                        _launchURL(url);
                      },
                  ),
                  const TextSpan(
                    text: "과 "
                  ),
                  TextSpan(
                    text: "이용약관",
                    style: myProfile_appInfo_content.copyWith(color: dalgeurakBlueOne, fontWeight: FontWeight.w600),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        String url = 'https://bit.ly/3rR3CHz';
                        _launchURL(url);
                      },
                  ),
                  const TextSpan(
                    text: "에\n동의하는 것으로 간주합니다."
                  )
                ],
              ),
              textAlign: TextAlign.start,
              style: myProfile_appInfo_content,
            ),
          ),
          // Positioned(
          //   bottom: Get.height * 0.1,
          //   left: Get.width * 0.06,
          //   child: GestureDetector(
          //     onTap: () => Get.to(LicensePage()),
          //     child: Container(
          //       color: Colors.transparent,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           Text("사용한 오픈소스의 라이선스 보러가기", style: myProfile_appInfo_license),
          //           SizedBox(width: 2),
          //           Icon(Icons.chevron_right_sharp, color: dalgeurakBlueOne, size: 16)
          //         ],
          //       ),
          //     ),
          //   ),
          // )
        ],
      )
  );


  void _launchURL(String _url) async =>
      await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return packageInfo.version;
  }
}