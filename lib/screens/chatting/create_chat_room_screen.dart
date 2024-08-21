import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateChatRoomScreen extends StatefulWidget {
  @override
  _CreateChatRoomScreenState createState() => _CreateChatRoomScreenState();
}

class _CreateChatRoomScreenState extends State<CreateChatRoomScreen> {
  final _chatRoomNameController = TextEditingController();
  String? _selectedUserId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅방 생성'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _chatRoomNameController,
              decoration: InputDecoration(labelText: '채팅방 이름'),
            ),
            SizedBox(height: 20),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('users').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('사용자 목록을 불러오는 중 오류가 발생했습니다.'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('사용자 목록을 불러올 수 없습니다.'));
                }
                final users = snapshot.data!.docs;
                return DropdownButton<String>(
                  hint: Text('채팅할 사용자 선택'),
                  value: _selectedUserId,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedUserId = newValue;
                    });
                  },
                  items: users.map((user) {
                    return DropdownMenuItem<String>(
                      value: user.id,
                      child: Text(user['name'] ?? '이름 없음'),
                    );
                  }).toList(),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createChatRoom,
              child: Text('생성'),
            ),
          ],
        ),
      ),
    );
  }

  void _createChatRoom() async {
    final chatRoomName = _chatRoomNameController.text;
    final currentUserId = "anonymousUser"; // 로그인하지 않은 경우에 사용할 기본 사용자 ID

    if (chatRoomName.isEmpty || _selectedUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('채팅방 이름과 사용자 선택은 필수입니다.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('chatRooms').add({
        'name': chatRoomName,
        'users': [currentUserId, _selectedUserId],
        'lastMessage': 'No messages yet.',
        'createdAt': Timestamp.now(),
      });
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('채팅방 생성 실패: $e')),
      );
    }
  }
}
