import 'package:dalgeurak/controllers/auth_controller.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dalgeurak/screens/studentManage/student_mileage_store.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as di;

class ChatScreenState extends GetWidget<AuthController> {
  final String chatRoomId;
  ChatScreenState({required this.chatRoomId, Key? key}) : super(key: key);

  final _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode(); // FocusNode 추가

  final UserController userController = Get.find<UserController>();

  Future<void> sendMessage(String? message) async {

    if (message!.isEmpty) {
      return;
    }

    di.Response response = await dio.post(
      "$apiUrl/chat/chat",
      options: di.Options(contentType: "application/json"),
      data: {
        "room": chatRoomId,
        "message": message
      },
    );

    _messageController.clear();
    _focusNode.requestFocus();
    return response.data;
  }

  /*void _sendMessage(String message) async {
    // 로그인 여부와 관계없이 기본 사용자 ID 사용
    final userId = FirebaseAuth.instance.currentUser?.uid ??
        "anonymousUser"; // 로그인하지 않은 경우 기본 사용자 ID

    if (message.isEmpty) {
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .add({
        'text': message,
        'createdAt': Timestamp.now(),
        'userId': userId, // 기본 사용자 ID 저장
      });
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(chatRoomId)
          .update({
        'lastMessage': message,
        'lastMessageAt': Timestamp.now(),
      });
      _messageController.clear();
      _focusNode.requestFocus(); // 메시지 전송 후 다시 포커스를 TextField에 설정
    } catch (e) {
      print('메시지 전송 실패: $e');
    }
  }*/

  Future<void> _openMileageStore() async {
    final selectedEmoticon = await Get.to<String>(
          () => const StudentMileageStorePage(),
    );

    if (selectedEmoticon != null) {
      sendMessage(selectedEmoticon);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final currentUserId =
    //     FirebaseAuth.instance.currentUser?.uid ?? "anonymousUser";
    final currentUserId = userController.user?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('채팅방'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc(chatRoomId)
                  .collection('messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('메시지가 없습니다.'));
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
                          const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.symmetric(
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
                                      constraints: const BoxConstraints(
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
                                      constraints: const BoxConstraints(
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
                              const SizedBox(height: 5),
                              Text(
                                '${createdAt.toLocal()}',
                                style: const TextStyle(
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
                  icon: const Icon(Icons.emoji_emotions, color: Colors.blueAccent),
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
                    onSubmitted: sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () => sendMessage(_messageController.text),
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
          title: const Text("메시지 삭제"),
          content: const Text("이 메시지를 삭제하시겠습니까?"),
          actions: [
            TextButton(
              child: const Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("삭제"),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('chatRooms')
                    .doc(chatRoomId)
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
