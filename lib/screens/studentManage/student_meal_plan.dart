import 'package:flutter/material.dart';

class StudentMealPlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2024년 9월 식단표'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Image.asset('assets/emoticons/emoticon1.jpg', height: 50),
                Text(
                  '2024년 9월 식단표',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //Image.asset('assets/emoticons/emoticon2.jpg', height: 50),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: Table(
                border: TableBorder.all(color: Colors.black),
                children: [
                  _buildTableRow(['월요일', '화요일', '수요일', '목요일', '금요일'],
                      isHeader: true),
                  _buildTableRow([
                    '4일\n찰보리밥\n무도톰탕\n애호박볶음\n브로콜리/초장\n배추김치/열천교말이',
                    '5일\n하이라이스덮밥\n순두부찌개\n치즈까스/머스터드\n오이/깍두기\n배추김치',
                    '6일\n비빔밥\n감자된장국\n어묵볶음\n배추김치\n체리뽕',
                    '7일\n차조소밥\n돼지갈비찜\n우엉조림\n양상추샐러드\n깍두기/송편',
                    '8일\n개교기념일',
                  ]),
                  _buildTableRow([
                    '11일\n차조소밥\n대지갈비찜\n두부부침/구이\n배추김치\n브로콜리/초장',
                    '12일\n기장쌀밥\n콩나물국\n멸치볶음\n배추김치\n요거트',
                    '13일\n검정콩밥\n된장찌개\n고추장무침\n배추김치\n감자채볶음',
                    '14일\n현미밥\n쇠고기무국\n콩나물\n배추김치\n유자차',
                    '15일\n쌀밥\n무청된장국\n연어구이\n배추김치\n귤',
                  ]),
                  _buildTableRow([
                    '18일\n기장쌀밥\n청국장\n감자채볶음\n배추김치\n파인애플',
                    '19일\n콩나물밥\n미역국\n연두부찜\n배추김치\n피자바게트',
                    '20일\n콩나물밥\n어묵탕\n닭봉\n김치',
                    '21일\n카레라이스\n고추장무침\n배추김치\n오렌지',
                    '22일\n찰보리밥\n대구매운탕\n오징어채볶음\n배추김치\n사과',
                  ]),
                  _buildTableRow([
                    '25일\n검정콩밥\n얼큰순두부국\n우엉조림\n깍두기\n찐감자',
                    '26일\n현미밥\n된장국\n어묵볶음\n배추김치\n양상추샐러드',
                    '27일\n찰보리밥\n순두부찌개\n배추김치\n단무지',
                    '28일\n백미밥\n매운어묵탕\n닭고기볶음\n배추김치\n샤인머스켓',
                    '29일\n혼합잡곡밥\n순두부된장국\n건포도연두부찜\n김구이\n유자차',
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell,
            style: TextStyle(
              fontSize: isHeader ? 16 : 14,
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.black : Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }
}
