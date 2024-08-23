import 'package:dalgeurak/screens/auth/login_success.dart';
import 'package:dalgeurak/screens/chatting/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'create_chat_room_screen.dart';

class ChatRoomCard extends StatelessWidget {
  final String chatRoomId;
  final String name;
  final String lastMessage;
  final String profileImageUrl; // 프로필 이미지 URL을 위한 변수 추가

  ChatRoomCard({
    required this.chatRoomId,
    required this.name,
    required this.lastMessage,
    required this.profileImageUrl, // 생성자에 프로필 이미지 URL 포함
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(profileImageUrl), // 로컬 이미지 사용
        ),
        title: Text(
          name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          lastMessage,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _showDeleteOptionsDialog(context, chatRoomId);
          },
        ),
        onTap: () {
          Get.to(ChatScreenState(
            chatRoomId: chatRoomId,
          ));
        },
      ),
    );
  }

  void _showDeleteOptionsDialog(BuildContext context, String chatRoomId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('삭제 옵션 선택'),
          content: Text('채팅방 삭제 옵션을 선택하세요.'),
          actions: [
            TextButton(
              onPressed: () {
                _deleteChatRoom(context, chatRoomId);
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('채팅방만 삭제'),
            ),
            TextButton(
              onPressed: () {
                _deleteChatRoomWithMessages(context, chatRoomId);
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('메시지 포함 전체 삭제'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  void _deleteChatRoom(BuildContext context, String chatRoomId) async {
    try {
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('채팅방이 삭제되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('채팅방 삭제에 실패했습니다: $e')),
      );
    }
  }

  void _deleteChatRoomWithMessages(BuildContext context, String chatRoomId) async {
    try {
      // 하위 컬렉션의 메시지들 먼저 삭제
      var messagesSnapshot = await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .get();

      for (var doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      // 채팅방 삭제
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('채팅방과 모든 메시지가 삭제되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('전체 삭제에 실패했습니다: $e')),
      );
    }
  }
}
