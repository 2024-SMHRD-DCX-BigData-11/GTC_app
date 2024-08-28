import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:dalgeurak/data/Question.dart';
import 'package:dalgeurak/utils/toast.dart';
import 'package:dio/dio.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:get/get.dart';

class StudentEducationRecordPage extends StatefulWidget {
  @override
  _StudentEducationRecordPageState createState() =>
      _StudentEducationRecordPageState();
}

class _StudentEducationRecordPageState
    extends State<StudentEducationRecordPage> {
  String? _selectedSemester;
  String? _selectedUnit;
  String? _selectedSubUnit;
  String? _selectedDifficulty;

  UserController userController = Get.find<UserController>();

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

  late Future<List<Question>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchDataFromApi();
  }

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
                    "${userController.user?.name}님을 위한 추천 문제 보기",
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
                      _dataFuture = _fetchDataFromApi();
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
                  children: const [
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
            SizedBox(height: 10),
            FutureBuilder<List<Question>>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<Question> questions = snapshot.data!;
                  print('questions.length : ${questions.length}');

                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    // ListView 내부의 스크롤을 비활성화
                    shrinkWrap: true,
                    // ListView가 필요한 만큼만 공간을 차지하도록 설정
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      var question = questions[index];
                      return Column(
                        children: [
                          SizedBox(height: 30),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(height: 10),
                                Text(question.name),
                                SizedBox(height: 10),
                                Image.network(
                                  "$apiUrl/save/${question.name}",
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 10),
                                OutlinedButton(
                                  onPressed: () {
                                    print('문제 풀기 버튼 클릭됨');
                                  },
                                  child: const Text('문제 풀기'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No Data Available'));
                }
              },
            ),
          ],
        ),
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
      showToast("학년 / 학기를 먼저 선택해주세요.");
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

Future<List<Question>> _fetchDataFromApi() async {
  try {
    di.Response response = await dio.post(
      "$apiUrl/question/random",
      options: di.Options(contentType: "application/json"),
    );

    List<dynamic> jsonList = response.data;
    List<Question> questions =
        jsonList.map((json) => Question.fromJson(json)).toList();

    return questions;
  } catch (e) {
    throw Exception('Failed to load data: $e');
  }
}
