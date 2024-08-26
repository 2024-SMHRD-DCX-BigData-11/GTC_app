import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html; // 웹 환경에서만 사용

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    // Firestore에서 저장된 프로필 이미지 URL을 불러옵니다.
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc('rjsduf')
        .get();
    setState(() {
      _imageUrl = snapshot['profileImageUrl'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 4;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _showBottomSheet,
                child: Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    image: DecorationImage(
                      image: _imageUrl == null
                          ? const AssetImage(
                                  "assets/images/default_profile_image.png")
                              as ImageProvider
                          : NetworkImage(_imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCameraImage,
              child: const Text('사진 찍기'),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 3),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: getPhotoLibraryImage,
              child: const Text('갤러리에서 선택'),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 3),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _resetToDefaultImage, // 기본 이미지로 되돌리는 버튼
              child: const Text('기본 이미지로 설정'),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Future<void> _getCameraImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      await _uploadImage(File(pickedFile.path));
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
    Navigator.of(context).pop(); // BottomSheet 닫기
  }

  Future<void> getPhotoLibraryImage() async {
    if (kIsWeb) {
      _getPhotoLibraryImageWeb();
    } else {
      _getPhotoLibraryImage();
    }
    Navigator.of(context).pop(); // BottomSheet 닫기
  }

  Future<void> _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _uploadImage(File(pickedFile.path));
      await _loadProfileImage();
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  Future<void> _getPhotoLibraryImageWeb() async {
    final input = html.FileUploadInputElement();
    input.accept = 'image/*'; // Optional: filter to only image files
    input.click();

    input.onChange.listen((e) async {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        await uploadImageWeb(file);
        await _loadProfileImage();
      } else {
        if (kDebugMode) {
          print('이미지 선택안함');
        }
      }
    });
  }

  Future<void> _uploadImage(File file) async {
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
          .doc('rjsduf')
          .update({
        'profileImageUrl': downloadUrl,
      });

      // 상태 업데이트
      setState(() {
        _imageUrl = downloadUrl;
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> uploadImageWeb(html.File file) async {
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
            .doc('rjsduf')
            .update({
          'profileImageUrl': downloadUrl,
        });

        setState(() {
          _imageUrl = downloadUrl;
        });
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _resetToDefaultImage() async {
    // 기본 이미지로 설정 (Firestore에서 이미지 URL 제거)
    await FirebaseFirestore.instance.collection('users').doc('user_id').update({
      'profileImageUrl': FieldValue.delete(),
    });

    // 기본 상태로 설정
    setState(() {
      _imageUrl = null;
    });

    Navigator.of(context).pop(); // BottomSheet 닫기
  }
}
