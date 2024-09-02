import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/data/class_info.dart';
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
  late Future<ClassInfo> classInfo;
  final List<String> grades = ["1학년", "2학년", "3학년", "4학년", "5학년", "6학년"];


  @override
  void initState() {
    super.initState();
    classInfo = loadClassInfo();
  }

  Future<ClassInfo> loadClassInfo() async {
    try {
      di.Response response = await dio.post(
        "$apiUrl/class/info",
        options: di.Options(contentType: "application/json"),
      );

      var json = response.data;
      ClassInfo classInfo = ClassInfo.fromJson(json);

      return classInfo;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ClassInfo>(
      future: classInfo, // classInfo는 비동기 작업으로부터 데이터를 가져옵니다.
      builder: (BuildContext context, AsyncSnapshot<ClassInfo> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          ); // 로딩 중일 때 표시할 위젯
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          ); // 에러가 발생했을 때 표시할 위젯
        } else if (snapshot.hasData) {
          final classInfo = snapshot.data!;
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
                  Text(classInfo.name, style: dialogTitle, textAlign: TextAlign.left),
                  const SizedBox(height: 16),
                  const Divider(color: dalgeurakGrayOne, thickness: 1.0),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text("담임 선생님 ", style: inquiryDialogEmailTitle),
                      Text(classInfo.ownerName, style: inquiryDialogEmailAddress),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("학생 목록 (${classInfo.students.length}명)", style: inquiryDialogEmailTitle),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: classInfo.students.length,
                      itemBuilder: (context, index) {
                        final student = classInfo.students[index];

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: student.imageUrl == null
                                ? const AssetImage("assets/images/default_profile_image.png")
                            as ImageProvider
                                : NetworkImage(student.imageUrl!),
                          ),
                          title: Text(student.name!),
                          subtitle: Text("마지막 활동일 : ${student.updatedAt}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // _showRemoveDialog(context, student.id);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text('No data found'));
        }
      },
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
