import 'package:dalgeurak/screens/studentManage/student_mileage_store.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  final String chatRoomId;

  ChatScreen({required this.chatRoomId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // FocusNode 추가

  void _sendMessage(String message) async {
    // 로그인 여부와 관계없이 기본 사용자 ID 사용
    final userId = "anonymousUser";  // 로그인하지 않은 경우 사용할 기본 사용자 ID

    if (message.isEmpty) {
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('chatRooms').doc(widget.chatRoomId).collection('messages').add({
        'text': message,
        'createdAt': Timestamp.now(),
        'userId': userId,  // 기본 사용자 ID 저장
      });
      await FirebaseFirestore.instance.collection('chatRooms').doc(widget.chatRoomId).update({
        'lastMessage': message,
        'lastMessageAt': Timestamp.now(),
      });
      _messageController.clear();
      _focusNode.requestFocus(); // 메시지 전송 후 다시 포커스를 TextField에 설정
    } catch (e) {
      print('메시지 전송 실패: $e');
    }
  }

  Future<void> _openMileageStore() async {
    final selectedEmoticon = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => StudentMileageStorePage()),
    );

    if (selectedEmoticon != null) {
      _sendMessage(selectedEmoticon);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅방'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.emoji_emotions),
            onPressed: _openMileageStore, // 이모티콘 상점 열기
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc(widget.chatRoomId)
                  .collection('messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text('메시지가 없습니다.'));
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (ctx, index) {
                    final message = messages[index];
                    final messageText = message['text'];
                    final createdAt = (message['createdAt'] as Timestamp).toDate();
                    return ListTile(
                      title: messageText.contains('assets/')
                          ? Image.asset(messageText) // 이모티콘을 이미지로 표시
                          : Text(messageText),
                      subtitle: Text('${createdAt.toLocal()}'),
                      onLongPress: () {
                        _confirmDeleteMessage(context, message.id); // 메시지 삭제 확인 다이얼로그 표시
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _focusNode, // FocusNode 연결
                    decoration: InputDecoration(labelText: '메시지 입력'),
                    onSubmitted: (value) {
                      _sendMessage(value);  // 엔터 키를 누르면 메시지 전송
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_messageController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteMessage(BuildContext context, String messageId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('메시지 삭제'),
        content: Text('이 메시지를 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('chatRooms')
                  .doc(widget.chatRoomId)
                  .collection('messages')
                  .doc(messageId)
                  .delete();
              Navigator.of(ctx).pop();
            },
            child: Text('삭제'),
          ),
        ],
      ),
    );
  }
}
