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
  late TabController _tabController;
  late Future<List<Friend>> friendsList;
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    friendsList = _loadFriends();
  }

  Future<List<Friend>> _loadFriends() async {
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

  Future<void> _addFriend(String nickname) async {
    try {
      di.Response response = await dio.post("$apiUrl/friend/add",
          options: di.Options(contentType: "application/json"),
          data: {
            'username': nickname,
          });

      if (response.statusCode == 200) {
        print('친구 추가 성공: ${response.data}');
        _loadFriends();
      } else {
        print('친구 추가 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<void> _removeFriend(String nickname) async {
    try {
      di.Response response = await dio.post("$apiUrl/friend/remove",
          options: di.Options(contentType: "application/json"),
          data: {
            'username': nickname,
          });

      if (response.statusCode == 200) {
        print('친구 추가 성공: ${response.data}');
        _loadFriends();
      } else {
        print('친구 추가 실패: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('친구 관리'),
        backgroundColor: Colors.blueAccent,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '목록'),
            Tab(text: '친구 추가'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder<List<Friend>>(
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
                      leading: const CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://your-image-url.com'), // Placeholder for user image
                      ),
                      title: Text(friend.name),
                      subtitle: Text("마지막 활동일 : ${friend.updatedAt}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _removeFriend(friend.name);
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(
                    labelText: '닉네임 입력',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_nicknameController.text.isNotEmpty) {
                      _addFriend(_nicknameController.text);
                    }
                  },
                  child: const Text('친구 추가'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
