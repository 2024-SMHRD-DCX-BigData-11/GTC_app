import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/themes/color_theme.dart';
import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/themes/text_theme.dart';
import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/widgets/dialog.dart';
import 'package:dalgeurak/plugins/dimigoin_flutter_plugin/lib/dimigoin_flutter_plugin.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';


class StudentManageDialog {

  final DalgeurakDialog _dalgeurakDialog = DalgeurakDialog();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _classContorller = TextEditingController();

  void showProfileEditDialog(UserController userController) {
    Get.dialog(
      Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: SizedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(width: Get.width * 0.85, height: Get.height * 0.4),
              Positioned(
                top: Get.height * 0.03,
                left: Get.width * 0.08,
                child: const Text("프로필 수정", style: dialogTitle), // 기존 다이얼로그 타이틀 스타일 사용
              ),
              Positioned(
                top: Get.height * 0.06,
                child: SizedBox(
                  width: Get.width * 0.64,
                  child: const Divider(color: dalgeurakGrayOne, thickness: 1.0),
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
                        decoration: const BoxDecoration(
                          color: dalgeurakBlueOne,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16)),
                        ),
                        child: const Center(child: Text("저장", style: dialogBtn)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: Get.width * 0.4,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: dalgeurakGrayThree,
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(16)),
                        ),
                        child: const Center(child: Text("취소", style: dialogBtn)),
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
}
