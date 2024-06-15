import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/flashcard.dart';

class FlashcardData extends ChangeNotifier {
  final CollectionReference flashcardCollection =
      FirebaseFirestore.instance.collection('flashcards');

  List<Flashcard> _flashcards = [];

  List<Flashcard> get flashcards => _flashcards;

  Future<void> fetchFlashcards() async {
    try {
      QuerySnapshot snapshot = await flashcardCollection.get();
      _flashcards = snapshot.docs
          .map((doc) => Flashcard.fromDocumentSnapshot(doc))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching flashcards: $e');
    }
  }

  Future<void> addFlashcard(Flashcard flashcard) async {
    try {
      await flashcardCollection.add({
        'question': flashcard.question,
        'answer': flashcard.answer,
      });
      fetchFlashcards();
    } catch (e) {
      print('Error adding flashcard: $e');
    }
  }

  Future<void> editFlashcard(Flashcard flashcard) async {
    try {
      await flashcardCollection.doc(flashcard.id).update({
        'question': flashcard.question,
        'answer': flashcard.answer,
      });
      fetchFlashcards();
    } catch (e) {
      print('Error updating flashcard: $e');
    }
  }

  Future<void> deleteFlashcard(String id) async {
    try {
      await flashcardCollection.doc(id).delete();
      _flashcards.removeWhere((flashcard) => flashcard.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting flashcard: $e');
    }
  }
}
