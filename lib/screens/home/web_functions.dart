import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
      final bytes = reader.result as Uint8List;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(file.name);

      await storageRef.putData(bytes);
      final downloadUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'profileImageUrl': downloadUrl,
      });
    });
  } catch (e) {
    print('Error uploading image: $e');
  }
}