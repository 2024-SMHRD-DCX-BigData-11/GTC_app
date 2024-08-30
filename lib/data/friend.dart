class Friend {
  final int id;
  final String name;
  final String updatedAt;

  Friend({
    required this.id,
    required this.name,
    required this.updatedAt,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      name: json['name'],
      updatedAt: json['updated_at'],
    );
  }
}
