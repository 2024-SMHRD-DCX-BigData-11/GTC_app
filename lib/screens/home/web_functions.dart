import 'dart:convert';
import 'dart:html' as html;
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dio/dio.dart' as di;
import 'package:flutter/foundation.dart'; // 웹 환경에서만 사용

Future<void> getPhotoLibraryImage(String userId) async {
  final input = html.FileUploadInputElement();
  input.accept = 'image/*'; // Optional: filter to only image files
  input.click();

  input.onChange.listen((e) async {
    final files = input.files;
    if (files != null && files.isNotEmpty) {
      final file = files[0];
      await uploadImage(file, userId);
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  });
}

Future<void> uploadImageA(String path, String userId) async {
  return;
}

Future<void> uploadImage(html.File file, String userId) async {
  try {
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    reader.onLoadEnd.listen((e) async {
      final fileBytes = reader.result as Uint8List;
      String base64Image = base64Encode(fileBytes);
      // HTTP 요청에 사용될 MultipartRequest
      di.Response response = await dio.post(
        "$apiUrl/upload/profile",
        options: di.Options(contentType: "application/json"),
        data: {"file": base64Image, "fileName": file.name},
      );
    });
  } catch (e) {
    print('Error uploading image: $e');
  }
}
