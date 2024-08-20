import 'package:dalgeurak/utils/stringUtils.dart';
import 'package:flutter/material.dart';

class StudentMileageStorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 마일리지 상점 데이터를 하드코딩
    final List<Map<String, dynamic>> storeItems = [
      {"item": "안녕 리부트", "price": 3000, "image": "assets/emoticons/emoticon1.jpg"},
      {"item": "창구는 못말려", "price": 3000, "image": "assets/emoticons/emoticon2.jpg"},
      {"item": "메이플 이모티콘1", "price": 300, "image": "assets/emoticons/emoticon3.gif"},
      {"item": "메이플 이모티콘2", "price": 300, "image": "assets/emoticons/emoticon4.gif"},
      {"item": "메이플 이모티콘3", "price": 300, "image": "assets/emoticons/emoticon5.gif"},
      {"item": "메이플 이모티콘4", "price": 300, "image": "assets/emoticons/emoticon6.gif"},
      {"item": "메이플 이모티콘5", "price": 300, "image": "assets/emoticons/emoticon7.gif"},
      {"item": "메이플 이모티콘6", "price": 300, "image": "assets/emoticons/emoticon8.gif"},
      {"item": "창섭에몽", "price": 3000, "image": "assets/emoticons/emoticon9.jpg"},
      {"item": "창섭의 꿈", "price": 3000, "image": "assets/emoticons/emoticon10.jpg"},
      {"item": "신창섭", "price": 3000, "image": "assets/emoticons/emoticon11.jpg"},
      {"item": "춤창섭", "price": 3000, "image": "assets/emoticons/emoticon12.gif"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('마일리지 상점'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 한 줄에 4개씩 배치
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.7,
          ),
          itemCount: storeItems.length,
          itemBuilder: (context, index) {
            final item = storeItems[index];

            return GestureDetector(
              onTap: () {
                _showPurchaseDialog(context, item['image'], item['item'], item['price']);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          item['image'],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Text(
                      "${item['price']} 마일리지",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, String imagePath, String itemName, int price) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('이모티콘 구매'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                imagePath,
                height: 100,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 16),
              Text("현재 이모티콘을 구매하시겠습니까?"),
              SizedBox(height: 8),
              Text("가격: $price 마일리지"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 구매 처리 로직 추가
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$itemName${getParticle(itemName)} 구매했습니다.')),
                );
              },
              child: Text('예'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('아니요'),
            ),
          ],
        );
      },
    );
  }
}
