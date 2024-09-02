class Friend {
  final int id;
  final String name;
  final String updatedAt;
  final String? profileImageURL;

  Friend({
    required this.id,
    required this.name,
    required this.updatedAt,
    required this.profileImageURL,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      name: json['name'],
      updatedAt: json['updated_at'],
      profileImageURL: json['profile_image_url'],
    );
  }
}
