import 'package:dalgeurak_widget_package/widgets/blue_button.dart';
import 'package:dalgeurak_widget_package/widgets/oneline_textfield.dart';
import 'package:dalgeurak_widget_package/widgets/reason_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../themes/color_theme.dart';
import '../../themes/text_theme.dart';
import 'checkbox.dart';

class DalgeurakDialog {
  TextEditingController textFieldDialogFieldController = TextEditingController();
  RxBool isNoticeDialogNeverShow = false.obs;

  showWarning(String message, String subMessage, dynamic executeFunc) {
    Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: Get.width * 0.851, height: Get.height * 0.2),
                Positioned(
                  top: Get.height * 0.02,
                  child: Text("Warning", style: dialogTitle)
                ),
                Positioned(
                  top: Get.height * 0.07,
                  child: Text(
                    message,
                    style: warningDialog_message,
                  ),
                ),
                Positioned(
                  top: Get.height * 0.105,
                  child: Text(subMessage, style: warningDialog_subMessage),
                ),
                Positioned(
                    bottom: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            width: Get.width * 0.4,
                            height: 44,
                            decoration: BoxDecoration(
                                color: dalgeurakGrayThree,
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16))
                            ),
                            child: Center(child: Text("취소", style: dialogBtn)),
                          ),
                        ),
                        GestureDetector(
                          onTap: executeFunc,
                          child: Container(
                            width: Get.width * 0.4,
                            height: 44,
                            decoration: BoxDecoration(
                                color: dalgeurakBlueOne,
                                borderRadius: BorderRadius.only(bottomRight: Radius.circular(16))
                            ),
                            child: Center(child: Text("확인", style: dialogBtn)),
                          ),
                        ),
                      ],
                    ),
                ),
              ],
            ),
          ),
        )
    );
  }

  showNotice(String message, String btnName, dynamic executeFunc) => Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          height: Get.height * 0.27,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16))
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(width: Get.width * 0.851, height: Get.height * 0.23),
                    Positioned(
                        top: Get.height * 0.02,
                        child: Text("Notice", style: dialogTitle)
                    ),
                    Positioned(
                      top: Get.height * 0.07,
                      child: Text(
                        message,
                        style: noticeDialog_message,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: GestureDetector(
                        onTap: executeFunc,
                        child: Container(
                          width: Get.width * 0.8,
                          height: 44,
                          decoration: BoxDecoration(
                              color: dalgeurakBlueOne,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))
                          ),
                          child: Center(child: Text(btnName, style: dialogBtn)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: Get.width * 0.755,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => GestureDetector(
                          onTap: () => isNoticeDialogNeverShow.value = !(isNoticeDialogNeverShow.value),
                          child: DalgeurakCheckBox(content: "다시 보지않기", isOn: isNoticeDialogNeverShow.value, checkBoxType: DalgeurakCheckBoxType.dialog))),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text("닫기", style: noticeDialog_menu.copyWith(decoration: TextDecoration.underline))
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
  );

  showTextField(Function(String reasonText) executeFunc) => Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: SizedBox(
          height: Get.height * 0.22,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(16))
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: Get.height * 0.03,
                  left: 24,
                  child: Text("거절 사유", style: dialogTitle),
                ),
                Positioned(
                  top: Get.height * 0.072,
                  child: Center(child: OneLineTextField(hintText: "거절 사유를 입력해주세요.", textController: textFieldDialogFieldController, isEnable: true, isSmall: true))
                ),
                Positioned(
                  bottom: Get.height * 0.025,
                  child: GestureDetector(
                    onTap: () => executeFunc,
                    child: BlueButton(content: "확인", isLong: false, isSmall: false, isFill: true, isDisable: false)
                  ),
                )
              ],
            ),
          ),
        ),
      )
  );

  showInquiry() => Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(width: Get.width * 0.851, height: Get.height * 0.26),
            Positioned(
              top: Get.height * 0.03,
              left: Get.width * 0.08,
              child: Text("문의하기", style: dialogTitle)
            ),
            Positioned(
              top: Get.height * 0.06,
              child: Container(width: Get.width * 0.64, child: Divider(color: dalgeurakGrayOne, thickness: 1.0))
            ),
            Positioned(
              top: Get.height * 0.09,
              left: Get.width * 0.08,
              child: Text("문의사항은 아래 연락처로 보내주시면\n빠른 시일 내로 답변 드리도록 하겠습니다."),
            ),
            Positioned(
              top: Get.height * 0.145,
              left: Get.width * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("E-mail", style: inquiryDialog_emailTitle),
                  SizedBox(width: 4),
                  Text("dimigoin2022@dimigo.hs.kr", style: inquiryDialog_emailAddress)
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: Get.width * 0.8,
                  height: 44,
                  decoration: BoxDecoration(
                    color: dalgeurakBlueOne,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))
                  ),
                  child: Center(child: Text("확인", style: dialogBtn)),
                ),
              ),
            )
          ],
        ),
      ),
    )
  );

  showList(String subTitle, String title, String contentKind, ListView? listView) {
    Widget contentWidget;

    if (listView == null) {
      contentWidget = Positioned(
        top: Get.height * 0.32,
        child: Text("$contentKind이(가) 없어요!", style: listDialog_listEmpty),
      );
    } else {
      contentWidget = Positioned(
        top: Get.height * 0.17,
        child: SizedBox(
          width: Get.width * 0.58,
          height: Get.height * 0.425,
          child: listView,
        ),
      );
    }

    Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          child: Container(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(width: Get.width * 0.851, height: Get.height * 0.67),
                Positioned(
                    top: Get.height * 0.05,
                    left: Get.width * 0.085,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$subTitle", style: listDialog_subTitle),
                        SizedBox(height: 4),
                        Text("$title", style: listDialog_title)
                      ],
                    )
                ),
                Positioned(
                    top: Get.height * 0.05,
                    right: Get.width * 0.085,
                    child: GestureDetector(
                        onTap: () => Get.back(),
                        child: SvgPicture.asset("assets/images/close.svg", package: "dalgeurak_widget_package", width: 20, color: dalgeurakGrayThree)
                    )
                ),
                Positioned(
                    top: Get.height * 0.137,
                    child: Container(width: Get.width * 0.64, child: Divider(color: dalgeurakGrayTwo, thickness: 1.0))
                ),
                contentWidget,
                Positioned(
                  bottom: Get.height * 0.04,
                  child: Container(width: Get.width * 0.64, child: Divider(color: dalgeurakGrayTwo, thickness: 1.0)),
                )
              ],
            ),
          ),
        )
    );
  }
}