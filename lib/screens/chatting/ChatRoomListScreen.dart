import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';
import 'create_chat_room_screen.dart';

class ChatRoomListScreen extends StatelessWidget {
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
              );
            },
          );
        },
      ),
    );
  }
}

class ChatRoomCard extends StatelessWidget {
  final String chatRoomId;
  final String name;
  final String lastMessage;

  ChatRoomCard({
    required this.chatRoomId,
    required this.name,
    required this.lastMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          lastMessage,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                chatRoomId: chatRoomId,
              ),
            ),
          );
        },
      ),
    );
  }
}
