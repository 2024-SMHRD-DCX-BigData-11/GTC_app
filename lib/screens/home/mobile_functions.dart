import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

Future<void> getPhotoLibraryImage(String userId) async {
  final pickedFile =
  await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    await uploadImage(File(pickedFile.path), userId);
  } else {
    if (kDebugMode) {
      print('이미지 선택안함');
    }
  }
}

Future<void> uploadImageA(String path, String userId) async {
  uploadImage(File(path), userId);
}

Future<void> uploadImage(File file, String userId) async {
  try {
    String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child(fileName);

    // 파일 업로드
    await storageRef.putFile(file);

    // 업로드 완료 후 다운로드 URL 가져오기
    String downloadUrl = await storageRef.getDownloadURL();

    // Firestore에 이미지 URL 저장
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({
      'profileImageUrl': downloadUrl,
    });
  } catch (e) {
    print('Error uploading image: $e');
  }
}