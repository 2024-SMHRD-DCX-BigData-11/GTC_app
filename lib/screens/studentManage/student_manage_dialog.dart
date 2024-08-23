import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/themes/color_theme.dart';
import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/themes/text_theme.dart';
import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/widgets/dialog.dart';
import 'package:dalgeurak/plugins/dimigoin_flutter_plugin/lib/dimigoin_flutter_plugin.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:dalgeurak_widget_package/widgets/blue_button.dart';
import 'package:dalgeurak_widget_package/widgets/oneline_textfield.dart';
import 'package:dalgeurak_widget_package/widgets/reason_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


class StudentManageDialog {

  DalgeurakDialog _dalgeurakDialog = DalgeurakDialog();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _classContorller = TextEditingController();

  void showProfileEditDialog(UserController userController) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Container(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(width: Get.width * 0.85, height: Get.height * 0.4),
              Positioned(
                top: Get.height * 0.03,
                left: Get.width * 0.08,
                child: Text("프로필 수정", style: dialogTitle), // 기존 다이얼로그 타이틀 스타일 사용
              ),
              Positioned(
                top: Get.height * 0.06,
                child: Container(
                  width: Get.width * 0.64,
                  child: Divider(color: dalgeurakGrayOne, thickness: 1.0),
                ),
              ),
              Positioned(
                top: Get.height * 0.09,
                left: Get.width * 0.08,
                right: Get.width * 0.08,
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: '이름'),
                      controller: _nameController,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(labelText: '학년'),
                      controller: _gradeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: const InputDecoration(labelText: '반'),
                      controller: _classContorller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        userController.updateProfile(_nameController.text, int.parse(_gradeController.text), int.parse(_classContorller.text));
                        Get.back();
                      },
                      child: Container(
                        width: Get.width * 0.4,
                        height: 44,
                        decoration: BoxDecoration(
                          color: dalgeurakBlueOne,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16)),
                        ),
                        child: Center(child: Text("저장", style: dialogBtn)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: Get.width * 0.4,
                        height: 44,
                        decoration: BoxDecoration(
                          color: dalgeurakGrayThree,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(16)),
                        ),
                        child: Center(child: Text("취소", style: dialogBtn)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showWarningDialog(List<DalgeurakWarning> warningList) => _dalgeurakDialog.showList(
      "경고",
      "누적 ${warningList.length}회",
      "경고 기록",
      ListView.builder(
          itemCount: warningList.length,
          itemBuilder: (context, index) {
            DalgeurakWarning warning = warningList[index];

            String warningTypeStr = "";
            warning.warningTypeList?.forEach((element) => warningTypeStr = warningTypeStr + element.convertKorStr + ", ");
            warningTypeStr = warningTypeStr.substring(0, warningTypeStr.length-2);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${Jiffy(warning.date).format("MM.dd (E) a hh:mm")}", style: myProfile_warning_date),
                SizedBox(height: 2),
                Text("$warningTypeStr(${warning.reason})", style: myProfile_warning_reason),
                SizedBox(height: 20),
              ],
            );
          }
      )
  );

  showCheckInRecordDialog(String studentName) => _dalgeurakDialog.showList(
      studentName,
      "입장 기록",
      "입장 기록",
      null
  );
}
