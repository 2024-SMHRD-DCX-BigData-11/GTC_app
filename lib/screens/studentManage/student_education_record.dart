import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentEducationRecordPage extends StatefulWidget {
  @override
  _StudentEducationRecordPageState createState() => _StudentEducationRecordPageState();
}

class _StudentEducationRecordPageState extends State<StudentEducationRecordPage> {
  int _currentIndex = 0;

  List<BottomNavigationBarItem> bottomNavigatorItem = [
    BottomNavigationBarItem(
      label: "홈",
      icon: SvgPicture.asset('assets/images/icons/home_select.svg'),
    ),
    BottomNavigationBarItem(
      label: "게임",
      icon: SvgPicture.asset('assets/images/icons/gaming.svg'),
    ),
    BottomNavigationBarItem(
      label: "채팅",
      icon: SvgPicture.asset('assets/images/icons/calendar_unselect.svg'),
    ),
    BottomNavigationBarItem(
      label: "내 정보",
      icon: SvgPicture.asset('assets/images/icons/user_unselect.svg'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            Text(
              "MATH TUTOR",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "신규가입을 축하드립니다!\n이 공간에는 구독자를 지정하면 최신 피드가 뜹니다.\n많은 구독자들을 지정해보세요!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: Icon(Icons.menu, color: Colors.black),
        actions: [
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.notifications, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[300],
            child: Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "스인재님을 위한 추천 문제 보기",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCategoryButton("초중고"),
                _buildCategoryButton("학년/과"),
                _buildCategoryButton("대단원"),
                _buildCategoryButton("중단원"),
                _buildCategoryButton("난이도"),
                _buildCategoryButton("초기화"),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "모든 사용자들의 피드에 등록된 문제/답변 set 중에서 문항들을\n좋아요 순으로 검색할 수 있습니다.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "실시간으로 자료를 불러오기 때문에 시간이 다소 걸릴 수 있습니다.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavigatorItem,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildCategoryButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.grey[300],
          onPrimary: Colors.black,
        ),
        onPressed: () {},
        child: Text(text),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StudentEducationRecordPage(),
  ));
}
