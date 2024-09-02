import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/themes/color_theme.dart';
import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/themes/text_theme.dart';
import 'package:dalgeurak/utils/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as di;

class ClassManageDialog extends StatefulWidget {
  const ClassManageDialog({Key? key}) : super(key: key);

  @override
  _ClassManageDialogState createState() => _ClassManageDialogState();
}

class _ClassManageDialogState extends State<ClassManageDialog> {
  final UserController userController = Get.find<UserController>();
  final TextEditingController _nameController = TextEditingController();
  String? selectedGrade;
  int? _selectedIndex;
  final List<String> grades = ["1학년", "2학년", "3학년", "4학년", "5학년", "6학년"];

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
            const Text("반 어쩌고", style: dialogTitle, textAlign: TextAlign.left),
            const SizedBox(height: 16),
            const Divider(color: dalgeurakGrayOne, thickness: 1.0),
            const SizedBox(height: 16),
            Row(
              children: const [
                Text("반 이름 ", style: inquiryDialogEmailTitle),
                Text("양건열과 바보들", style: inquiryDialogEmailAddress),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Text("학년 ", style: inquiryDialogEmailTitle),
                Text("5학년", style: inquiryDialogEmailAddress),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchDataFromApi(String name, int grade) async {
    di.Response response = await dio.post(
      "$apiUrl/class/create",
      options: di.Options(contentType: "application/json"),
      data: {"name": name, "grade": grade},
    );
    userController.user?.setClassId = response.data['class_id'];
    userController.user?.setOwner = true; // 선생님
    Get.back();
    showToast("반 생성이 완료되었습니다.");
    return response.data;
  }
}
