import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/widgets/dialog.dart';
import 'package:dalgeurak/plugins/dimigoin_flutter_plugin/lib/dimigoin_flutter_plugin.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class StudentManageDialog {

  DalgeurakDialog _dalgeurakDialog = DalgeurakDialog();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _classContorller = TextEditingController();

  void showProfileEditDialog(UserController userController) {
    Get.dialog(
      AlertDialog(
        title: const Text('프로필 수정'),
        content: SizedBox(
          width: 300, // 다이얼로그의 너비를 조절합니다.
          child: ListView(
            shrinkWrap: true, // ListView가 자식 위젯의 크기에 맞게 조절되도록 합니다.
            children: [
              TextField(
                decoration: const InputDecoration(labelText: '이름'),
                controller: _nameController,
                // onChanged: (value) => userController.user.update((user) {
                //   user?.name = value;
                // }),
              ),
              TextField(
                decoration: const InputDecoration(labelText: '학년'),
                controller: _gradeController,
                keyboardType: TextInputType.number, // 키보드 타입을 숫자로 설정
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 허용
                ],
                // onChanged: (value) => userController.user.update((user) {
                //   user?.gradeNum = int.tryParse(value) ?? 0;
                // }),
              ),
              TextField(
                decoration: const InputDecoration(labelText: '반'),
                controller: _classContorller,
                keyboardType: TextInputType.number, // 키보드 타입을 숫자로 설정
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 허용
                ],
                // onChanged: (value) => userController.user.update((user) {
                //   user?.classNum = int.tryParse(value) ?? 0;
                // }),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              userController.updateProfile(_nameController.text, int.parse(_gradeController.text), int.parse(_classContorller.text)); // 프로필 업데이트 호출
              Get.back();
            },
            child: const Text('저장'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('취소'),
          ),
        ],
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
