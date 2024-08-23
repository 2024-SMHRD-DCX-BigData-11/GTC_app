import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';  // 이미지 선택을 위한 패키지
import 'package:firebase_storage/firebase_storage.dart';  // Firebase Storage 사용
import 'package:cloud_firestore/cloud_firestore.dart';  // Firestore 사용
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  String? _uploadedFileURL;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('갤러리에서 선택'),
              onTap: () async {
                final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    _image = File(pickedFile.path);
                    _uploadedFileURL = null;  // 새 이미지를 선택했으므로 기존 업로드 URL을 초기화
                  });
                }
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('기본 사진으로 설정'),
              onTap: () {
                setState(() {
                  _image = null;
                  _uploadedFileURL = null;  // 기본 사진으로 설정 시 업로드 URL 초기화
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;
    try {
      // Firebase Storage에 업로드
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(_image!);
      final url = await ref.getDownloadURL();

      // Firestore에 이미지 URL 저장
      await FirebaseFirestore.instance.collection('users').doc('user_id').update({
        'profileImageUrl': url,
      });

      setState(() {
        _uploadedFileURL = url;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 사진이 성공적으로 업로드되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('프로필 사진 업로드에 실패했습니다: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필 사진 등록'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: _uploadedFileURL != null
                  ? NetworkImage(_uploadedFileURL!)
                  : _image != null
                  ? FileImage(_image!) as ImageProvider
                  : AssetImage('assets/images/default_profile_image.png'),
              backgroundColor: Colors.grey[300],
              child: _uploadedFileURL == null && _image == null
                  ? Icon(Icons.person, size: 60)
                  : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('사진 선택'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _uploadImage,
              child: Text('사진 업로드'),
            ),
            SizedBox(height: 20),
            _uploadedFileURL != null
                ? Text('업로드된 URL: $_uploadedFileURL')
                : Container(),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
  ));
}
