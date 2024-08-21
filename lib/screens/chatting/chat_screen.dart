import 'package:dalgeurak/screens/studentManage/student_mileage_store.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    final userId = FirebaseAuth.instance.currentUser?.uid ??
        "anonymousUser"; // 로그인하지 않은 경우 기본 사용자 ID

    if (message.isEmpty) {
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(widget.chatRoomId)
          .collection('messages')
          .add({
        'text': message,
        'createdAt': Timestamp.now(),
        'userId': userId, // 기본 사용자 ID 저장
      });
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(widget.chatRoomId)
          .update({
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
    final currentUserId =
        FirebaseAuth.instance.currentUser?.uid ?? "anonymousUser";

    return Scaffold(
      appBar: AppBar(
        title: Text('채팅방'),
        backgroundColor: Colors.blueAccent,
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
                    final createdAt =
                        (message['createdAt'] as Timestamp).toDate();
                    final isCurrentUser = message['userId'] == currentUserId;

                    return Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: GestureDetector(
                        onLongPress: () {
                          _confirmDeleteMessage(
                              context, message.id); // 메시지 삭제 확인 다이얼로그 표시
                        },
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white, // 내부는 흰색
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isCurrentUser
                                  ? Colors.blueAccent
                                  : Colors.grey, // 테두리 색상
                              width: 2,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: isCurrentUser
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              messageText.contains('assets/')
                                  ? Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 150, // 최대 너비 설정
                                        maxHeight: 150, // 최대 높이 설정
                                      ),
                                      child: Image.asset(
                                        messageText,
                                        fit: BoxFit
                                            .contain, // 이미지의 비율을 유지하면서 박스에 맞게 조정
                                      ),
                                    )
                                  : Container(
                                      constraints: BoxConstraints(
                                        maxWidth: 150, // 최대 너비 설정
                                      ),
                                      child: Text(
                                        messageText,
                                        style: TextStyle(
                                          color: isCurrentUser
                                              ? Colors.blueAccent
                                              : Colors.black87,
                                          fontSize: 16,
                                        ),
                                      )),
                              SizedBox(height: 5),
                              Text(
                                '${createdAt.toLocal()}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
                IconButton(
                  icon: Icon(Icons.emoji_emotions, color: Colors.blueAccent),
                  onPressed: _openMileageStore, // 이모티콘 상점 열기
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: '메시지 입력...',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () => _sendMessage(_messageController.text),
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("메시지 삭제"),
          content: Text("이 메시지를 삭제하시겠습니까?"),
          actions: [
            TextButton(
              child: Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("삭제"),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('chatRooms')
                    .doc(widget.chatRoomId)
                    .collection('messages')
                    .doc(messageId)
                    .delete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
