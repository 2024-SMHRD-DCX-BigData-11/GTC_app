import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class FriendPage extends StatefulWidget {
  final String nickname;
  final bool isFriend;
  final VoidCallback onAction;

  FriendPage({
    required this.nickname,
    required this.isFriend,
    required this.onAction,
    Key? key,
  }) : super(key: key);

  @override
  _FriendPageState createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> friendsList = [];
  bool isLoading = true;
  final TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    final Dio dio = Dio();
    const String apiUrl = 'http://your-server-url/api';

    try {
      final response = await dio.get('$apiUrl/friends');
      if (response.statusCode == 200 && response.data.isNotEmpty) {
        setState(() {
          friendsList = List<Map<String, dynamic>>.from(response.data);
        });
      } else {
        print('친구 목록을 불러오는 데 실패했습니다.');
      }
    } catch (e) {
      print('친구 목록을 불러오는 중 오류 발생: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addFriend(String nickname) async {
    final Dio dio = Dio();
    const String apiUrl = 'http://your-server-url/api';

    try {
      final userResponse = await dio.get('$apiUrl/user', queryParameters: {'nickname': nickname});
      if (userResponse.statusCode == 200 && userResponse.data.isNotEmpty) {
        final user = userResponse.data[0];

        final response = await dio.post('$apiUrl/friend/add', data: {
          'username': user['username'],
          'nickname': user['nickname'],
          'class_id': user['class_id'],
        });

        if (response.statusCode == 200) {
          print('친구 추가 성공: ${response.data}');
          _loadFriends();
        } else {
          print('친구 추가 실패: ${response.statusCode}');
        }
      } else {
        print('사용자를 찾을 수 없습니다.');
      }
    } catch (e) {
      print('친구 추가 중 오류 발생: $e');
    }
  }

  Future<void> _removeFriend(String nickname) async {
    final Dio dio = Dio();
    const String apiUrl = 'http://your-server-url/api';

    try {
      final response = await dio.post('$apiUrl/friend/remove', data: {'nickname': nickname});

      if (response.statusCode == 200) {
        print('친구 삭제 성공: ${response.data}');
        _loadFriends();
      } else {
        print('친구 삭제 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('친구 삭제 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('친구 관리'),
        backgroundColor: Colors.blueAccent,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '목록'),
            Tab(text: '친구 추가'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: friendsList.length,
            itemBuilder: (context, index) {
              final friend = friendsList[index];
              final String nickname = friend['nickname'];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage('https://your-image-url.com'), // Placeholder for user image
                ),
                title: Text(nickname),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _removeFriend(nickname);
                  },
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                    labelText: '닉네임 입력',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_nicknameController.text.isNotEmpty) {
                      _addFriend(_nicknameController.text);
                    }
                  },
                  child: Text('친구 추가'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
