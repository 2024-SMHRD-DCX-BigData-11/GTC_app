import 'dart:convert';
import 'dart:html' as html;
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dio/dio.dart' as di;
import 'package:flutter/foundation.dart'; // 웹 환경에서만 사용

Future<void> getPhotoLibraryImage(Function onComplete) async {
  final input = html.FileUploadInputElement();
  input.accept = 'image/*'; // Optional: filter to only image files
  input.click();

  input.onChange.listen((e) async {
    final files = input.files;
    if (files != null && files.isNotEmpty) {
      final file = files[0];
      await uploadImage(file);
      onComplete(); // 파일 업로드가 완료된 후 호출
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  });
}

Future<void> uploadImageA(String path) async {
  return;
}

Future<void> uploadImage(html.File file) async {
  try {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    reader.onLoadEnd.listen((e) async {
      final fileBytes = reader.result as Uint8List;
      String base64Image = base64Encode(fileBytes);
      // HTTP 요청에 사용될 MultipartRequest
      di.Response response = await dio.post(
        "$apiUrl/profile/upload",
        options: di.Options(contentType: "application/json"),
        data: {"file": base64Image, "fileName": file.name},
      );
    });
  } catch (e) {
    print('Error uploading image: $e');
  }
}
