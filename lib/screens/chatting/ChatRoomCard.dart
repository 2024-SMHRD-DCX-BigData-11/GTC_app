import 'package:dalgeurak/screens/chatting/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart'; // badges 패키지 추가

class ChatRoomCard extends StatelessWidget {
  final String chatRoomId;
  final String name;
  final String lastMessage;
  final String profileImageUrl; // 프로필 이미지 URL

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
          backgroundImage: profileImageUrl.isNotEmpty
              ? NetworkImage(profileImageUrl)
              : AssetImage('assets/images/default_profile_image.png') as ImageProvider, // 상대방 프로필 이미지 또는 기본 이미지
        ),
        title: Text(
          name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          lastMessage,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 읽지 않은 메시지 수를 표시하는 Badge
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc(chatRoomId)
                  .collection('messages')
                  .where('isRead', isEqualTo: false) // 읽지 않은 메시지만 필터링
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Container(); // 데이터가 없으면 빈 컨테이너 반환
                }
                final unreadCount = snapshot.data!.docs.length;
                return unreadCount > 0
                    ? Badge(
                  badgeContent: Text(
                    unreadCount.toString(),
                    style: TextStyle(color: Colors.lightBlueAccent), // 여기서 수정
                  ),
                  badgeColor: Colors.red,
                )
                    : SizedBox.shrink(); // 읽지 않은 메시지가 없으면 아무것도 표시하지 않음
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _showDeleteOptionsDialog(context, chatRoomId);
              },
            ),
          ],
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
