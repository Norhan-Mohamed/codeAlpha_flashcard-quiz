import 'package:cloud_firestore/cloud_firestore.dart';

class Flashcard {
  final String id;
  final String question;
  final String answer;

  Flashcard({required this.id, required this.question, required this.answer});

  factory Flashcard.fromDocumentSnapshot(DocumentSnapshot doc) {
    return Flashcard(
      id: doc.id,
      question: doc['question'],
      answer: doc['answer'],
    );
  }
}
