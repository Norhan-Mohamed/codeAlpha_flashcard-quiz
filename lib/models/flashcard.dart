import 'package:cloud_firestore/cloud_firestore.dart';

class Flashcard {
  final String id;
  final String question;
  final String answer;

  const Flashcard({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory Flashcard.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data();
    if (data is! Map<String, dynamic>) {
      return Flashcard(id: doc.id, question: '', answer: '');
    }

    return Flashcard(
      id: doc.id,
      question: _readString(data['question']),
      answer: _readString(data['answer']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
    };
  }

  static String _readString(Object? value) {
    if (value is String) {
      return value.trim();
    }
    return '';
  }
}
