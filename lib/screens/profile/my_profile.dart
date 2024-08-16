import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyProfile extends StatelessWidget {
  MyProfile({Key? key}) : super(key: key);

  late double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[200], // 기본 배경 색상
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    SizedBox(width: Get.width, height: 140),
                    Positioned(
                      top: _height * 0.05,
                      left: _width * 0.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("5학년 1반", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text("신창숩", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Positioned(
                      right: -(_width * 0.125),
                      child: Image.asset(
                        "assets/images/home_flowerpot.png",
                        height: 124,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: _width * 0.897,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      margin: EdgeInsets.only(bottom: 15),
                      child: Center(
                        child: SizedBox(
                          width: _width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("알림 허용", style: TextStyle(fontSize: 16)),
                              FlutterSwitch(
                                height: 20,
                                width: 41,
                                padding: 3.0,
                                toggleSize: 14,
                                borderRadius: 21,
                                activeColor: Colors.blue,
                                value: true,
                                onToggle: (value) {
                                  // 토글 액션
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: _width * 0.897,
                      height: 240,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: EdgeInsets.only(bottom: 15),
                      child: Center(
                        child: SizedBox(
                          width: _width * 0.68,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildMenuButton(Icons.edit, "프로필 수정", "개인 정보 변경"),
                                    _buildMenuButton(Icons.schedule, "이번주 시간표", "확인하기"),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildMenuButton(Icons.restaurant_menu, "이번주 급식표", "확인하기"),
                                    _buildMenuButton(Icons.store, "마일리지 상점", "이용하기"),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 200,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildMenuButton(Icons.people, "이번 주 랭킹", "친구 추가/삭제"),
                                    _buildMenuButton(Icons.book, "교육 기록 보기", "조회하기"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: _width * 0.897,
                      height: 300, // 높이 조정 가능
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSimpleListButton("교육 기록 보기", Icons.book),
                          _buildSimpleListButton("문의하기", Icons.help_center),
                          _buildSimpleListButton("이번 주 랭킹", Icons.leaderboard),
                          _buildSimpleListButton("앱 정보", Icons.info_outline),
                          _buildSimpleListButton("로그아웃", Icons.exit_to_app, color: Colors.red),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String title, String subTitle) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.blue),
        SizedBox(height: 8),
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(subTitle, style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSimpleListButton(String title, IconData icon, {Color color = Colors.black}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      onTap: () {
        // 기능 구현 필요 없음, UI 디자인만 처리
      },
    );
  }
}
