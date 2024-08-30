import 'package:dalgeurak/data/friend.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dio/dio.dart' as di;

class CreateChatRoomScreen extends StatefulWidget {
  const CreateChatRoomScreen({Key? key}) : super(key: key);

  @override
  _CreateChatRoomScreenState createState() => _CreateChatRoomScreenState();
}

class _CreateChatRoomScreenState extends State<CreateChatRoomScreen> {
  late Future<List<Friend>> friendsList;
  final _chatRoomNameController = TextEditingController();
  String? _selectedUserId;

  @override
  void initState() {
    super.initState();
    friendsList = loadFriends();
  }

  Future<List<Friend>> loadFriends() async {
    try {
      di.Response response = await dio.post(
        "$apiUrl/friend/list",
        options: di.Options(contentType: "application/json"),
      );

      List<dynamic> jsonList = response.data;
      List<Friend> friends =
          jsonList.map((json) => Friend.fromJson(json)).toList();

      return friends;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅방 생성'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _chatRoomNameController,
              decoration: const InputDecoration(labelText: '채팅방 이름'),
            ),
            const SizedBox(height: 20),
            FutureBuilder<List<Friend>>(
              future: friendsList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                      child: Text('사용자 목록을 불러오는 중 오류가 발생했습니다.'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('사용자 목록을 불러올 수 없습니다.'));
                }
                final List<Friend> users = snapshot.data!;
                return DropdownButton<String>(
                  hint: const Text('채팅할 사용자 선택'),
                  value: _selectedUserId,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedUserId = newValue;
                    });
                  },
                  items: users.map((user) {
                    return DropdownMenuItem<String>(
                      value: user.id.toString(),
                      child: Text(user.name),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createChatRoom,
              child: const Text('생성'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createChatRoom() async {
    if (_chatRoomNameController.text.isEmpty) {
      return;
    }

    di.Response response = await dio.post(
      "$apiUrl/chat/createRoom",
      options: di.Options(contentType: "application/json"),
      data: {"room": _chatRoomNameController.text},
    );
    Navigator.of(context).pop();
    return response.data;
  }

  // void _createChatRoom() async {
  //   final chatRoomName = _chatRoomNameController.text;
  //   const currentUserId = "anonymousUser"; // 로그인하지 않은 경우에 사용할 기본 사용자 ID
  //
  //   if (chatRoomName.isEmpty || _selectedUserId == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('채팅방 이름과 사용자 선택은 필수입니다.')),
  //     );
  //     return;
  //   }
  //
  //   try {
  //     await FirebaseFirestore.instance.collection('chatRooms').add({
  //       'name': chatRoomName,
  //       'users': [currentUserId, _selectedUserId],
  //       'lastMessage': 'No messages yet.',
  //       'createdAt': Timestamp.now(),
  //     });
  //     Navigator.of(context).pop();
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('채팅방 생성 실패: $e')),
  //     );
  //   }
  // }
}
