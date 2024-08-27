import 'dart:convert';

import 'package:dalgeurak/dialogs/class_join_dialog.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dio/dio.dart' as di;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeController extends GetxController {
  ClassJoinDialog classJoinDialog = ClassJoinDialog();

  QRViewController? scanController;

  RxString qrImageData = "initData".obs;

  RxBool isLoading = false.obs; // 로딩 상태 관리

  setQrCodeData(String qrKey) async {
    String result = "dalgeurak_checkin_qr://";

    result = result + qrKey;

    qrImageData.value = result;
  }

  analyzeQrCodeData(String? scanResult) async {
    scanController!.pauseCamera();

    // isLoading.value = true; // 로딩 상태 시작

    // API 호출 예시
    final Map<String, dynamic> data = await fetchDataFromApi(scanResult);

    // isLoading.value = false; // 로딩 상태 종료

    Get.back();

    if (data['status'] == "success") {
      classJoinDialog.showDialog(data['data']);
    } else {
      showDialog("유효하지 않은 QR 코드입니다.\r\n다시 시도해주세요.");
    }

    // Get.dialog(showAlert(data));

    // scanController!.resumeCamera();
  }

  AlertDialog showAlert(Map<String, dynamic> map) {
    return AlertDialog(
      title: const Text('QR 인식 성공'),
      content: Text(jsonEncode(map)),
      actions: [
        TextButton(
          child: const Text("Close"),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> fetchDataFromApi(String? uuid) async {
    di.Response response = await dio.post(
      "$apiUrl/qrcode/scan",
      options: di.Options(contentType: "application/json"),
      data: {"uuid": uuid},
    );
    return response.data;
  }

  showToast(String message) => Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xE6FFFFFF),
        textColor: Colors.black,
        fontSize: 13.0,
      );

  void showDialog(String text) => Get.dialog(
        AlertDialog(
          title: const Text('알림'),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: Get.back,
              child: const Text('확인'),
            ),
          ],
        ),
      );
}
