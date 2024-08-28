class Question {
  final String name;
  final String sector1;
  final String sector2;

  Question({required this.name, required this.sector1, required this.sector2});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      name: json['name'],
      sector1: json['sector1'],
      sector2: json['sector2'],
    );
  }
}
