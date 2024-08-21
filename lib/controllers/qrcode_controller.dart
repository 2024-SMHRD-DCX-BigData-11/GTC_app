import 'dart:convert';

import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dio/dio.dart' as di;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class QrCodeController extends GetxController {

  final DalgeurakService _dalgeurakService = Get.find<DalgeurakService>();

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
    await _fetchDataFromApi();

    // isLoading.value = false; // 로딩 상태 종료

    Get.back();

    Get.dialog(showAlert());

    if (scanResult!.startsWith("dalgeurak_checkin_qr://")) {
      Map checkInResult = await _dalgeurakService.mealCheckInWithJWT(scanResult.substring(scanResult.indexOf("://")+3));

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

  AlertDialog showAlert()  {
    return AlertDialog(
      title: const Text('QR'),
      content: const Text('인식 성공'),
      actions: [
        TextButton(
          child: const Text("Close"),
          onPressed: () => Get.back(),
        ),
      ],
    );
  }

  Future<void> _fetchDataFromApi() async {
    di.Response response = await dio.post(
        "$apiUrl/qrcode/join",
      options: di.Options(contentType: "application/json"),
      data: {"테스트": "보냄"},
      
    );
    final responseBody = jsonEncode(response.data);
    print("ㅎㅇㅎㅇ : $responseBody");
  }

  showToast(String message) => Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xE6FFFFFF),
      textColor: Colors.black,
      fontSize: 13.0
  );
}