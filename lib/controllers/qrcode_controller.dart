import 'dart:convert';

import 'package:dalgeurak/dialogs/class_join_dialog.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dio/dio.dart' as di;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeController extends GetxController {
  final DalgeurakService _dalgeurakService = Get.find<DalgeurakService>();
  ClassJoinDialog classJoinDialog = const ClassJoinDialog();

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
    final data = await _fetchDataFromApi(scanResult);

    // isLoading.value = false; // 로딩 상태 종료

    Get.back();

    classJoinDialog.showDialog();

    // Get.dialog(showAlert(data));

    if (scanResult!.startsWith(apiUrl)) {
      Map checkInResult = await _dalgeurakService.mealCheckInWithJWT(
          scanResult.substring(scanResult.indexOf("://") + 3));

      if (checkInResult["result"] == "success") {
        showToast("${checkInResult['name']}님 체크인 되었습니다.");
      } else {
        showToast(checkInResult['content']);
      }
    } else {
      // showToast("달그락 체크인 QR코드가 아닙니다. \n다시 시도해주세요.");
    }

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

  Future<Map<String, dynamic>>_fetchDataFromApi(String? url) async {
    di.Response response = await dio.post(
      url ?? "$apiUrl/qrcode/join",
      options: di.Options(contentType: "application/json"),
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
      fontSize: 13.0);
}
