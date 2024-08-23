import 'package:dalgeurak/screens/auth/login_success.dart';
import 'package:dalgeurak/screens/chatting/ChatRoomCard.dart';
import 'package:dalgeurak/screens/chatting/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'create_chat_room_screen.dart';

class ChatRoomListScreen extends StatelessWidget {
  const ChatRoomListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅방 목록'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateChatRoomScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chatRooms').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('채팅방이 없습니다.'));
          }
          final chatRoomDocs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chatRoomDocs.length,
            itemBuilder: (ctx, index) {
              final chatRoom = chatRoomDocs[index];
              return ChatRoomCard(
                chatRoomId: chatRoom.id,
                name: chatRoom['name'],
                lastMessage: chatRoom['lastMessage'] ?? '아직 메시지가 없습니다.',
                profileImageUrl: chatRoom['profileImageUrl'] ?? 'https://example.com/default_profile_image.png', // 기본 프로필 이미지 URL 추가
              );
            },
          );
        },
      ),
    );
  }
}
