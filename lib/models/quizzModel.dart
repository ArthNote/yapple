import 'package:cloud_firestore/cloud_firestore.dart';

class quizzModel {
  String id;
  String title;
  List<quizzQuestion> questions;

  quizzModel({
    required this.id,
    required this.title,
    required this.questions,
  });

  factory quizzModel.fromJson(Map<String, dynamic> json) {
    List<quizzQuestion> questions = [];
    for (var question in json['questions']) {
      questions.add(quizzQuestion.fromJson(question));
    }
    return quizzModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      questions: questions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }

  factory quizzModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    List<quizzQuestion> questions = [];
    for (Map<String, dynamic> question in data['questions']) {
      questions.add(quizzQuestion.fromJson(question));
    }
    return quizzModel(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      questions: questions,
    );
  }
}


class quizzQuestion {
  String question;
  List<dynamic>? answers;
  int correctAnswerIndex;

  quizzQuestion({
    required this.question,
    this.answers,
    required this.correctAnswerIndex,
  });

  factory quizzQuestion.fromJson(Map<String, dynamic> json) {
    return quizzQuestion(
      question: json['question'],
      answers: json['answers'] ?? [],
      correctAnswerIndex: json['correctAnswerIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answers': answers,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }

  factory quizzQuestion.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return quizzQuestion(
      question: data['question'] ?? '',
      answers: data['answers'] ?? [],
      correctAnswerIndex: data['correctAnswerIndex'],
    );
  }
}