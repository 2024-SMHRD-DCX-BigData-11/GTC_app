import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? _pickedFile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    print('dgdgdgdgdgdgdgdgdgdgg');
  }

  Future<void> _loadProfileImage() async {
    // Firestore에서 저장된 프로필 이미지 URL을 불러옵니다.
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc('rjsduf').get();
    setState(() {
      _imageUrl = snapshot['profileImageUrl'];
      print('dgdgdgdgdgdgdgdgdgdgg' + snapshot['profileImageUrl']);
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
            if (_imageUrl == null)
              Container(
                constraints: BoxConstraints(
                  minHeight: imageSize,
                  minWidth: imageSize,
                ),
                child: GestureDetector(
                  onTap: _showBottomSheet,
                  child: Center(
                    child: Icon(
                      Icons.account_circle,
                      size: imageSize,
                    ),
                  ),
                ),
              )
            else
              Center(
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
                      image: NetworkImage(_imageUrl!),
                      fit: BoxFit.cover,
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
              onPressed: _getPhotoLibraryImage,
              child: const Text('라이브러리에서 불러오기'),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Future<void> _getCameraImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      await _uploadImage(File(pickedFile.path));
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
    Navigator.of(context).pop(); // BottomSheet 닫기
  }

  Future<void> _getPhotoLibraryImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await _uploadImage(File(pickedFile.path));
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
    Navigator.of(context).pop(); // BottomSheet 닫기
  }

  Future<void> _uploadImage(File file) async {
    // Firebase Storage에 업로드
    String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference storageRef = FirebaseStorage.instance.ref().child('profile_images').child(fileName);
    await storageRef.putFile(file);
    String downloadUrl = await storageRef.getDownloadURL();

    // Firestore에 이미지 URL 저장
    await FirebaseFirestore.instance.collection('users').doc('user_id').update({
      'profileImageUrl': downloadUrl,
    });

    setState(() {
      _imageUrl = downloadUrl;
    });
  }
}
