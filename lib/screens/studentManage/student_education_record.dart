import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudentEducationRecordPage extends StatefulWidget {
  @override
  _StudentEducationRecordPageState createState() =>
      _StudentEducationRecordPageState();
}

class _StudentEducationRecordPageState
    extends State<StudentEducationRecordPage> {
  int _currentIndex = 0;
  String? _selectedSemester;
  String? _selectedUnit;
  String? _selectedSubUnit;
  String? _selectedDifficulty;

  // 사용자 이름을 받아온다고 가정합니다.
  final String userName = "사용자 이름"; // 예: userController.user?.name;

  List<BottomNavigationBarItem> bottomNavigatorItem = [
    BottomNavigationBarItem(
      label: "홈",
      icon: SvgPicture.asset(
        'assets/images/icons/home_select.svg',
        width: 24,
        height: 24,
      ),
    ),
    BottomNavigationBarItem(
      label: "게임",
      icon: SvgPicture.asset(
        'assets/images/icons/gaming.svg',
        width: 24,
        height: 24,
      ),
    ),
    BottomNavigationBarItem(
      label: "채팅",
      icon: SvgPicture.asset(
        'assets/images/icons/calendar_unselect.svg',
        width: 24,
        height: 24,
      ),
    ),
    BottomNavigationBarItem(
      label: "내 정보",
      icon: SvgPicture.asset(
        'assets/images/icons/user_unselect.svg',
        width: 24,
        height: 24,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Icon(Icons.menu, color: Colors.black),
        actions: [
          Icon(Icons.search, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.notifications, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Image.asset(
              "assets/images/logo2.png",
              width: 300, // 이미지 크기를 줄임
              height: 150, // 이미지 크기를 줄임
            ),

            SizedBox(height: 20),
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "$userName님을 위한 추천 문제 보기",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildCategoryButton(
                    _selectedSemester ?? "학년/과",
                    onTap: _showSemesterSelection,
                  ),
                  _buildCategoryButton(
                    _selectedUnit ?? "대단원",
                    onTap: _showUnitSelection,
                  ),
                  _buildCategoryButton(
                    _selectedSubUnit ?? "중단원",
                    onTap: _showSubUnitSelection,
                  ),
                  _buildCategoryButton(
                    _selectedDifficulty ?? "난이도",
                    onTap: _showDifficultySelection,
                  ),
                  _buildCategoryButton("초기화", onTap: () {
                    setState(() {
                      _selectedSemester = null;
                      _selectedUnit = null;
                      _selectedSubUnit = null;
                      _selectedDifficulty = null;
                    });
                  }),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (_selectedSemester != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '선택된 학년/과: $_selectedSemester',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),
            if (_selectedUnit != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '선택된 대단원: $_selectedUnit',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),
            if (_selectedSubUnit != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '선택된 중단원: $_selectedSubUnit',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),
            if (_selectedDifficulty != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '선택된 난이도: $_selectedDifficulty',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "모든 사용자들의 피드에 등록된 문제/답변 set 중에서 문항들을\n좋아요 순으로 검색할 수 있습니다.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "실시간으로 자료를 불러오기 때문에 시간이 다소 걸릴 수 있습니다.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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

  Widget _buildCategoryButton(String text, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.blueAccent,
          side: BorderSide(color: Colors.blueAccent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }

  void _showSemesterSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('5학년 1학기'),
                onTap: () {
                  setState(() {
                    _selectedSemester = '5학년 1학기';
                    _selectedUnit = null;
                    _selectedSubUnit = null;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('5학년 2학기'),
                onTap: () {
                  setState(() {
                    _selectedSemester = '5학년 2학기';
                    _selectedUnit = null;
                    _selectedSubUnit = null;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUnitSelection() {
    final units = _selectedSemester == '5학년 1학기'
        ? [
      '자연수의 혼합 계산',
      '약수와 배수',
      '규칙과 대응',
      '약분과 통분',
      '분수의 덧셈과 뺄셈',
      '다각형의 둘레와 넓이',
    ]
        : _selectedSemester == '5학년 2학기'
        ? [
      '수의 범위와 어림하기',
      '분수의 곱셈',
      '합동과 대칭',
      '소수의 곱셈',
      '직육면체',
      '평균과 가능성',
    ]
        : [];

    if (units.isEmpty) {
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: units.map((unit) {
              return ListTile(
                title: Text(unit),
                onTap: () {
                  setState(() {
                    _selectedUnit = unit;
                    _selectedSubUnit = null;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showSubUnitSelection() {
    final subUnits = {
      '자연수의 혼합 계산': ['초5 자연수의 혼합 계산'],
      '약수와 배수': ['초5 약수와 배수', '초5 최대공약수와 최소공배수'],
      '규칙과 대응': ['규칙과 대응'],
      '약분과 통분': ['크기가 같은 분수', '약분과 통분', '분수와 소수의 크기 비교'],
      '분수의 덧셈과 뺄셈': ['분수의 덧셈과 뺄셈'],
      '다각형의 둘레와 넓이': ['다각형의 둘레', '다각형의 넓이'],
      '수의 범위와 어림하기': ['초5 수의 범위와 어림하기'],
      '분수의 곱셈': ['초5 분수의 곱셈'],
      '합동과 대칭': ['초5 합동', '초5 대칭'],
      '소수의 곱셈': ['초5 소수의 곱셈'],
      '직육면체': ['초5 직육면체', '초5 겨냥도와 전개도'],
      '평균과 가능성': ['평균과 가능성'],
    };

    if (_selectedUnit == null || !subUnits.containsKey(_selectedUnit!)) {
      return;
    }

    final selectedSubUnits = subUnits[_selectedUnit!]!;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: selectedSubUnits.map((subUnit) {
              return ListTile(
                title: Text(subUnit),
                onTap: () {
                  setState(() {
                    _selectedSubUnit = subUnit;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showDifficultySelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['상', '중', '하'].map((difficulty) {
              return ListTile(
                title: Text(difficulty),
                onTap: () {
                  setState(() {
                    _selectedDifficulty = difficulty;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StudentEducationRecordPage(),
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
  ));
}
