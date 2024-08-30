import 'package:dalgeurak/data/question.dart';

class QuestionHistory {
  final int id;
  final String uuid;
  final double accuracy;
  final bool isCorrect;
  final String solvedAt;
  final Question question;

  QuestionHistory(
      {required this.id,
      required this.uuid,
      required this.accuracy,
      required this.isCorrect,
      required this.solvedAt,
      required this.question});

  factory QuestionHistory.fromJson(Map<String, dynamic> json) {
    return QuestionHistory(
      id: json['id'],
      uuid: json['uuid'],
      accuracy: json['accuracy'],
      isCorrect: json['is_correct'],
      solvedAt: json['solved_at'],
      question: Question.fromJson(json['question']),
    );
  }
}
