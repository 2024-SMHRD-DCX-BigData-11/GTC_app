import 'package:dalgeurak/data/friend.dart';
import 'package:flutter/material.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dio/dio.dart' as di;

class FriendPage extends StatefulWidget {
  // final String nickname;
  // final bool isFriend;
  // final VoidCallback onAction;

  const FriendPage({
    // required this.nickname,
    // required this.isFriend,
    // required this.onAction,
    Key? key,
  }) : super(key: key);

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage>
    with SingleTickerProviderStateMixin {
  late Future<List<Friend>> friendsList;
  final TextEditingController _nicknameController = TextEditingController();
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    friendsList = loadFriends();

    _nicknameController.addListener(() {
      isButtonEnabled.value = _nicknameController.text.isNotEmpty;
    });
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

  Future<void> _addFriend(String username) async {
    try {
      di.Response response = await dio.post("$apiUrl/friend/add",
          options: di.Options(contentType: "application/json"),
          data: {
            'username': username,
          });

      setState(() {
        friendsList = loadFriends();
      });
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> _removeFriend(int userId) async {
    try {
      di.Response response = await dio.post("$apiUrl/friend/remove",
          options: di.Options(contentType: "application/json"),
          data: {
            'user_id': userId,
          });

      setState(() {
        friendsList = loadFriends();
      });
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  void _showAddFriendDialog() {
    _nicknameController.clear();
    isButtonEnabled.value = false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('친구 추가'),
          content: TextField(
            controller: _nicknameController,
            decoration: const InputDecoration(labelText: '친구 아이디'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('취소'),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isButtonEnabled,
              builder: (context, isEnabled, child) {
                return ElevatedButton(
                  onPressed: isEnabled
                      ? () {
                          String username = _nicknameController.text;
                          // 친구 추가 로직을 여기에 작성
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                          _addFriend(username);
                          // 예시: 친구 추가 후 리스트 갱신
                          // setState(() {
                          //   (friendsList as Future<List<Friend>>).then((friends) {
                          //     friends.add(
                          //         Friend(friendId, DateTime.now().toString()));
                          //   });
                          // });
                        }
                      : null, // 비활성화 시 null
                  child: const Text('확인'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구 관리'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Friend>>(
        future: friendsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Friend> friends = snapshot.data!;

            return ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: friend.profileImageURL == null
                        ? const AssetImage(
                                "assets/images/default_profile_image.png")
                            as ImageProvider
                        : NetworkImage(friend.profileImageURL!),
                  ),
                  title: Text(friend.name),
                  subtitle: Text("마지막 활동일 : ${friend.updatedAt}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _showRemoveDialog(context, friend.id);
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No Data Available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFriendDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('친구 삭제'),
          content: const Text('삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                _removeFriend(id);
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('삭제'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('취소'),
            ),
          ],
        );
      },
    );
  }
}
