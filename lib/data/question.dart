class Question {
  final int id;
  final String name;
  final String sector1;
  final String sector2;
  final int term;
  final int unit;
  final int subunit;
  final int difficulty;

  Question(
      {required this.id,
      required this.name,
      required this.sector1,
      required this.sector2,
      required this.term,
      required this.unit,
      required this.subunit,
      required this.difficulty});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      name: json['name'],
      sector1: json['sector1'],
      sector2: json['sector2'],
      term: json['term'],
      unit: json['unit'],
      subunit: json['subunit'],
      difficulty: json['difficulty'],
    );
  }
}
