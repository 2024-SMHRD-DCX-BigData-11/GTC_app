class Ranking {
  final int rank;
  final String name;
  final int score;

  Ranking({
    required this.rank,
    required this.name,
    required this.score,
  });

  factory Ranking.fromJson(Map<String, dynamic> json) {
    return Ranking(
      rank: json['rank'],
      name: json['name'],
      score: json['score'],
    );
  }
}
