import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/themes/color_theme.dart';
import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/themes/text_theme.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as di;

class ClassJoinDialog extends GetxController {

  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  void showDialog(Map<String, dynamic> data) =>
      Get.dialog(
        Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Container(
            width: Get.width * 0.8, // 다이얼로그 너비 조정
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min, // 다이얼로그의 높이를 콘텐츠에 맞게 조정
              crossAxisAlignment: CrossAxisAlignment.start, // 좌측 정렬
              children: [
                const Text("반 가입하기",
                    style: dialogTitle, textAlign: TextAlign.left),
                const SizedBox(height: 16),
                const Divider(color: dalgeurakGrayOne, thickness: 1.0),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("반 이름 ", style: inquiryDialogEmailTitle),
                    Text("${data['name']}", style: inquiryDialogEmailAddress),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text("선생님 ", style: inquiryDialogEmailTitle),
                    Text("${data['owner']}", style: inquiryDialogEmailAddress),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text("구성원 수 ", style: inquiryDialogEmailTitle),
                    Text("${data['count']}명", style: inquiryDialogEmailAddress),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "이 반에 가입하시겠습니까?",
                      style: myProfile_appInfo_content.copyWith(
                        color: dalgeurakBlueOne,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24), // 상단 콘텐츠와 버튼 사이의 여백
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => {
                          fetchDataFromApi(data['id']),
                        },
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.transparent, // 필요에 따라 배경색 설정
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "가입",
                            style: TextStyle(
                              color: Colors.blue, // iOS 스타일 버튼 색상
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.transparent, // 필요에 따라 배경색 설정
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                            ),
                          ),
                          child: const Text(
                            "취소",
                            style: TextStyle(
                              color: Colors.blue, // iOS 스타일 버튼 색상
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Future<Map<String, dynamic>> fetchDataFromApi(int cid) async {
    di.Response response = await dio.post(
      "$apiUrl/class/join",
      options: di.Options(contentType: "application/json"),
      data: {"id": cid},
    );
    userController.updateClassId(cid);
    Get.back();
    _showToast("가입되었습니다.");
    return response.data;
  }

  void _showToast(String content) => Fluttertoast.showToast(
      msg: content,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xE6FFFFFF),
      textColor: Colors.black,
      fontSize: 13.0
  );
}
