import 'package:dalgeurak/data/Ranking.dart';
import 'package:flutter/material.dart';
import 'package:dalgeurak/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';
import 'package:dio/dio.dart' as di;

class StudentRankingPage extends StatefulWidget {
  const StudentRankingPage({Key? key}) : super(key: key);

  @override
  _StudentRankingPageState createState() => _StudentRankingPageState();
}

class _StudentRankingPageState extends State<StudentRankingPage> {
  late Future<List<Ranking>> rankings;
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    rankings = loadRanking();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Ranking>>(
      future: rankings, // classInfo는 비동기 작업으로부터 데이터를 가져옵니다.
      builder: (BuildContext context, AsyncSnapshot<List<Ranking>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          ); // 로딩 중일 때 표시할 위젯
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          ); // 에러가 발생했을 때 표시할 위젯
        } else if (snapshot.hasData) {
          final rankingInfo = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('주간 랭킹'),
              backgroundColor: Colors.blue,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '명예의 전당',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: rankingInfo.length,
                      itemBuilder: (context, index) {
                        final ranking = rankingInfo[index];
                        return RankingTile(
                          rank: ranking.rank,
                          name: ranking.name,
                          score: ranking.score,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text('200', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text('No data found'));
        }
      },
    );
  }
}

class RankingTile extends StatelessWidget {
  final int rank;
  final String name;
  final int score;

  const RankingTile(
      {Key? key, required this.rank, required this.name, required this.score})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(
            (rank == 1
                ? Icons.star
                : (rank == 2 ? Icons.star_half : Icons.star_border)),
            color: Colors.orange),
        title: Text(name),
        trailing: Text(
          '$score',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Rank: $rank'),
      ),
    );
  }
}

Future<List<Ranking>> loadRanking() async {
  try {
    di.Response response = await dio.post(
      "$apiUrl/ranking/list",
      options: di.Options(contentType: "application/json"),
    );

    // 이 부분에서 List<dynamic>으로 명시적 캐스팅
    var json = response.data as List<dynamic>;

    // json.map의 결과를 List<Ranking>로 변환
    List<Ranking> rankings = json
        .map((item) => Ranking.fromJson(item as Map<String, dynamic>))
        .toList();

    return rankings;
  } catch (e) {
    throw Exception('Failed to load data: $e');
  }
}
