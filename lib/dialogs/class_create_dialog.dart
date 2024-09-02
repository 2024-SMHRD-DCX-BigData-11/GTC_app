import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/themes/color_theme.dart';
import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/themes/text_theme.dart';
import 'package:dalgeurak/utils/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dalgeurak/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as di;

class ClassCreateDialog extends StatefulWidget {
  @override
  _ClassCreateDialogState createState() => _ClassCreateDialogState();
}

class _ClassCreateDialogState extends State<ClassCreateDialog> {
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
            const Text("반 만들기", style: dialogTitle, textAlign: TextAlign.left),
            const SizedBox(height: 16),
            const Divider(color: dalgeurakGrayOne, thickness: 1.0),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text("반 이름 ", style: inquiryDialogEmailTitle),
                Expanded(
                  child: TextField(
                    style: inquiryDialogEmailAddress,
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.singleLineFormatter,
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("학년 ", style: inquiryDialogEmailTitle),
                DropdownButton<String>(
                  value: selectedGrade,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGrade = newValue;  // 선택된 값을 업데이트합니다.
                      _selectedIndex = grades.indexOf(newValue!) + 1;
                    });
                  },
                  items: grades.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 24), // 상단 콘텐츠와 버튼 사이의 여백
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => {
                      fetchDataFromApi(_nameController.text, _selectedIndex!),
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
                        "만들기",
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
    );
  }

  Future<Map<String, dynamic>> fetchDataFromApi(String name, int grade) async {
    di.Response response = await dio.post(
      "$apiUrl/class/create",
      options: di.Options(contentType: "application/json"),
      data: {"name": name, "grade": grade},
    );
    // userController.user?.setClassId = cid;
    Get.back();
    showToast("반 생성이 완료되었습니다.");
    return response.data;
  }
}
