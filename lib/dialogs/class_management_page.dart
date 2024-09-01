import 'package:flutter/material.dart';

class ClassManagementPage extends StatelessWidget {
  final String grade;
  final String className;

  // Dummy data for students. In a real application, this would come from a database or API.
  final List<Map<String, dynamic>> students = [
    {'name': '김영희', 'achievement': ''},
    {'name': '이철수', 'achievement': ''},
    {'name': '박지수', 'achievement': ''},
    {'name': '정민수', 'achievement': ''},
    {'name': '최강민', 'achievement': ''},
  ];

  ClassManagementPage({
    Key? key,
    required this.grade,
    required this.className,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sorting students by name in ascending order.
    students.sort((a, b) => a['name'].compareTo(b['name']));

    return Scaffold(
      appBar: AppBar(
        title: Text("$grade $className 관리"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "학생 목록",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text((index + 1).toString()),
                    ),
                    title: Text(student['name']),
                    subtitle: Text('수업 성취도: ${student['achievement']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
