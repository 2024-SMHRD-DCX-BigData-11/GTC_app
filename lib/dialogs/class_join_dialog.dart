import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/themes/color_theme.dart';
import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/themes/text_theme.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassJoinDialog extends StatelessWidget {
  const ClassJoinDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  void showDialog() =>
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
                  children: const [
                    Text("반 이름 ", style: inquiryDialogEmailTitle),
                    Text("양건열과 아이들", style: inquiryDialogEmailAddress),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Text("선생님 ", style: inquiryDialogEmailTitle),
                    Text("양건열", style: inquiryDialogEmailAddress),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Text("구성원 수 ", style: inquiryDialogEmailTitle),
                    Text("18명", style: inquiryDialogEmailAddress),
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
                // const Text("이 반에 가입하시겠습니까?", textAlign: TextAlign.left),
                const SizedBox(height: 24), // 상단 콘텐츠와 버튼 사이의 여백
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
