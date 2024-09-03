import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/data/class_info.dart';
import 'package:dalgeurak/dialogs/image_dialog.dart';
import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/themes/color_theme.dart';
import 'package:dalgeurak/plugins/dalgeurak-widget-package/lib/themes/text_theme.dart';
import 'package:dalgeurak/utils/toast.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as di;

class ClassManageDialog extends StatefulWidget {
  const ClassManageDialog({Key? key}) : super(key: key);

  @override
  _ClassManageDialogState createState() => _ClassManageDialogState();
}

class _ClassManageDialogState extends State<ClassManageDialog> {
  final UserController userController = Get.find<UserController>();

  ImageDialog imageDialog = ImageDialog();

  final Rxn<ClassInfo> _classInfo = Rxn<ClassInfo>();

  @override
  void initState() {
    super.initState();
    loadClassInfo();
  }

  Future<ClassInfo> loadClassInfo() async {
    try {
      di.Response response = await dio.post(
        "$apiUrl/class/info",
        options: di.Options(contentType: "application/json"),
      );

      var json = response.data;
      ClassInfo classInfo = ClassInfo.fromJson(json);

      _classInfo.value = classInfo;

      return classInfo;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_classInfo.value == null) {
        return const Center(
          child: CircularProgressIndicator(),
        ); // 로딩 중일 때 표시할 위젯
      } else {
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
                Text((_classInfo.value?.name)!,
                    style: dialogTitle, textAlign: TextAlign.left),
                const SizedBox(height: 16),
                const Divider(color: dalgeurakGrayOne, thickness: 1.0),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text("담임 선생님 ", style: inquiryDialogEmailTitle),
                    Text((_classInfo.value?.ownerName)!,
                        style: inquiryDialogEmailAddress),
                  ],
                ),
                const SizedBox(height: 16),
                Text("구성원 목록 (${(_classInfo.value?.students)!.length}명)",
                    style: inquiryDialogEmailTitle),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _classInfo.value?.students.length,
                    itemBuilder: (context, index) {
                      final DimigoinUser student =
                          (_classInfo.value?.students)![index];

                      return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: student.imageUrl == null
                                ? const AssetImage(
                                        "assets/images/default_profile_image.png")
                                    as ImageProvider
                                : NetworkImage(student.imageUrl!),
                          ),
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // 텍스트를 왼쪽으로 정렬
                            children: [
                              Text(
                                student.name!,
                              ),
                              if (_classInfo.value?.owner == student.id)
                                const Text(
                                  "[선생님]", // 두 번째 텍스트
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    // 예시 스타일: 기본 글씨체
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Text("마지막 활동일 : ${student.updatedAt}"),
                          trailing: (userController.user?.id ==
                                      _classInfo.value?.owner &&
                                  userController.user?.id != student.id)
                              ? IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    showKickDialog(student);
                                  },
                                )
                              : null);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => {
                          ImageDialog.showImageDialog(
                              context, "$apiUrl/qrcode/generate"),
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
                            "초대 QR 코드",
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
                        onTap: () => {
                          showLeaveDialog(
                              userController.user?.id == _classInfo.value?.owner
                                  ? "정말로 해체하시겠습니까?"
                                  : "정말로 탈퇴하시겠습니까?"),
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
                          child: Text(
                            userController.user?.id == _classInfo.value?.owner
                                ? "해체하기"
                                : "탈퇴하기",
                            style: const TextStyle(
                              color: Colors.red, // iOS 스타일 버튼 색상
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
                            "닫기",
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
    });
  }

  Future<Map<String, dynamic>> fetchDataFromApi(String name, int grade) async {
    di.Response response = await dio.post(
      "$apiUrl/class/create",
      options: di.Options(contentType: "application/json"),
      data: {"name": name, "grade": grade},
    );
    userController.updateClassId(response.data['class_id']);
    userController.user?.setOwner = true; // 선생님
    Get.back();
    showToast("반 생성이 완료되었습니다.");
    return response.data;
  }

  void showKickDialog(DimigoinUser student) => Get.dialog(
        AlertDialog(
          title: const Text('알림'),
          content: Text("${student.name}님을 추방하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () {
                kick(student.id!);
                Get.back();
              },
              child: const Text(
                '추방',
                style: TextStyle(
                  color: Colors.red, // iOS 스타일 버튼 색상
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: Get.back,
              child: const Text('취소'),
            ),
          ],
        ),
      );

  void showLeaveDialog(String text) => Get.dialog(
        AlertDialog(
          title: const Text('알림'),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () {
                leaveClass();
                Get.back();
              },
              child: const Text(
                '탈퇴',
                style: TextStyle(
                  color: Colors.red, // iOS 스타일 버튼 색상
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: Get.back,
              child: const Text('취소'),
            ),
          ],
        ),
      );

  Future<Map<String, dynamic>> leaveClass() async {
    di.Response response = await dio.post(
      "$apiUrl/class/leave",
      options: di.Options(contentType: "application/json"),
    );
    userController.updateClassId(null);
    userController.user?.setOwner = null; // 선생님
    Get.back();
    showToast("반에서 나왔습니다.");
    return response.data;
  }

  Future<Map<String, dynamic>> kick(int userId) async {
    di.Response response = await dio.post(
      "$apiUrl/class/kick",
      options: di.Options(contentType: "application/json"),
      data: {"user_id": userId},
    );
    showToast("추방했습니다.");
    loadClassInfo();
    return response.data;
  }
}
