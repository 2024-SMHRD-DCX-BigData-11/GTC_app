import 'package:dalgeurak/screens/studentManage/qrcode_scan.dart';
import 'package:dalgeurak/screens/widgets/medium_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'class_management_page.dart';

class ClassDialog extends StatelessWidget {
  const ClassDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  void showDialog() => Get.dialog(
    Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: IntrinsicWidth(
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Container(
                        width: 120,
                        height: 120,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: MediumMenuButton(
                            iconName: "flag",
                            title: "반 만들기",
                            subTitle: "생성",
                            clickAction: () => {
                              Get.back(),
                              Get.to(() => ClassCreationPage()),
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Container(
                        width: 120,
                        height: 120,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: MediumMenuButton(
                            iconName: "qrCode",
                            title: "반 등록하기",
                            subTitle: "QR 코드",
                            clickAction: () => {
                              Get.back(),
                              Get.to(QrCodeScan()),
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    ),
  );
}

class ClassCreationPage extends StatefulWidget {
  const ClassCreationPage({Key? key}) : super(key: key);

  @override
  _ClassCreationPageState createState() => _ClassCreationPageState();
}

class _ClassCreationPageState extends State<ClassCreationPage> {
  String? selectedGrade;
  String? selectedClass;

  final List<String> grades = ["1학년", "2학년", "3학년", "4학년", "5학년", "6학년"];
  final List<String> classes = ["1반", "2반", "3반", "4반", "5반"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("반 만들기"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("학년 선택"),
            DropdownButton<String>(
              value: selectedGrade,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGrade = newValue;
                });
              },
              items: grades.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text("반 선택"),
            DropdownButton<String>(
              value: selectedClass,
              onChanged: (String? newValue) {
                setState(() {
                  selectedClass = newValue;
                });
              },
              items: classes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: selectedGrade != null && selectedClass != null
                    ? () {
                  Get.to(() => ClassManagementPage(
                    grade: selectedGrade!,
                    className: selectedClass!,
                  ));
                }
                    : null,
                child: const Text("반 관리 페이지로 이동"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
