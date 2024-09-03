import 'package:dimigoin_flutter_plugin/dimigoin_flutter_plugin.dart';

class ClassInfo {
  final int id;
  final String name;
  final int owner;
  final String ownerName;
  final List<DimigoinUser> students;

  ClassInfo({
    required this.id,
    required this.name,
    required this.owner,
    required this.ownerName,
    required this.students,
  });

  factory ClassInfo.fromJson(Map<String, dynamic> json) {
    return ClassInfo(
      id: json['id'],
      name: json['name'],
      owner: json['owner'],
      ownerName: json['owner_name'],
      students: (json['students'] as List<dynamic>)
          .map((item) => DimigoinUser.fromJson(item))
          .toList(),
    );
  }
}
