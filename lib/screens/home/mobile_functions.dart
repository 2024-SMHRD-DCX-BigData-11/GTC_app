import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dio/dio.dart' as di;

Future<void> getPhotoLibraryImage(Function onComplete) async {
  final pickedFile =
  await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    await uploadImageToServer(File(pickedFile.path));
  } else {
    if (kDebugMode) {
      print('이미지 선택안함');
    }
  }
}

Future<void> uploadImageA(String path) async {
  uploadImageToServer(File(path));
}

Future<void> uploadImageToServer(File file) async {
  try {
    List<int> fileBytes = await file.readAsBytes();
    String base64Image = base64Encode(fileBytes);
    // HTTP 요청에 사용될 MultipartRequest
    di.Response response = await dio.post(
      "$apiUrl/profile/upload",
      options: di.Options(contentType: "application/json"),
      data: {"file": base64Image, "fileName": file.path
          .split('/')
          .last,},
    );
  } catch (e) {
    print('Error uploading image: $e');
  }
}