import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 현재 로그인된 사용자를 가져옵니다.
    User? currentUser = FirebaseAuth.instance.currentUser;

    // 사용자가 로그인되어 있지 않다면
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('로그인이 필요합니다'),
        ),
        body: Center(
          child: Text('로그인 후에 이용할 수 있습니다.'),
        ),
      );
    }

    // 사용자가 로그인되어 있다면
    return Scaffold(
      appBar: AppBar(
        title: Text('환영합니다, ${currentUser.email}!'),
      ),
      body: Center(
        child: Text('Firebase에 연결된 데이터에 접근할 수 있습니다.'),
      ),
    );
  }
}
