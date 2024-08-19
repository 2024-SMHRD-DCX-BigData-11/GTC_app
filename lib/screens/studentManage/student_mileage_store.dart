import 'package:flutter/material.dart';

class StudentMileageStorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 마일리지 상점 데이터를 하드코딩
    final storeItems = [
      {"item": "이모티콘 1", "price": 300, "image": "assets/emoticons/emoticon1.jpg"},
      {"item": "이모티콘 2", "price": 300, "image": "assets/emoticons/emoticon2.jpg"},
      {"item": "이모티콘 3", "price": 300, "image": "assets/emoticons/emoticon3.png"},
      {"item": "이모티콘 4", "price": 300, "image": "assets/emoticons/emoticon4.gif"},
      {"item": "이모티콘 5", "price": 300, "image": "assets/emoticons/emoticon5.gif"},
      {"item": "이모티콘 6", "price": 300, "image": "assets/emoticons/emoticon6.png"},
      {"item": "이모티콘 7", "price": 300, "image": "assets/emoticons/emoticon7.png"},
      {"item": "이모티콘 8", "price": 300, "image": "assets/emoticons/emoticon8.png"},
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
            return GestureDetector(
              onTap: () {
                // 아이템을 선택했을 때의 처리
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${storeItems[index]['item']}를(을) 장바구니에 추가했습니다."))
                );
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
                          storeItems[index]['image'],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Text(
                      "${storeItems[index]['price']} 마일리지",
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
}
