import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/flashcard.dart';

class FlashcardData extends ChangeNotifier {
  FlashcardData({CollectionReference? collection})
      : _flashcardCollection =
            collection ?? FirebaseFirestore.instance.collection('flashcards');

  FlashcardData.forTesting({
    List<Flashcard> flashcards = const [],
    bool isLoading = false,
    String? errorMessage,
  })  : _flashcardCollection = null,
        _flashcards = List<Flashcard>.from(flashcards),
        _isLoading = isLoading,
        _errorMessage = errorMessage;

  final CollectionReference? _flashcardCollection;

  List<Flashcard> _flashcards = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Flashcard> get flashcards => List.unmodifiable(_flashcards);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => !_isLoading && _flashcards.isEmpty && _errorMessage == null;

  Future<void> fetchFlashcards() async {
    final collection = _flashcardCollection;
    if (collection == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await collection.get();
      _flashcards = snapshot.docs
          .map(Flashcard.fromDocumentSnapshot)
          .where((card) => card.question.isNotEmpty && card.answer.isNotEmpty)
          .toList();
      _errorMessage = null;
    } catch (error) {
      _errorMessage = _friendlyError(error);
      debugPrint('Error fetching flashcards: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addFlashcard(Flashcard flashcard) async {
    final collection = _flashcardCollection;
    if (collection == null) {
      _flashcards = [..._flashcards, flashcard];
      notifyListeners();
      return true;
    }

    try {
      await collection.add(flashcard.toMap());
      await fetchFlashcards();
      return true;
    } catch (error) {
      _errorMessage = _friendlyError(error);
      notifyListeners();
      debugPrint('Error adding flashcard: $error');
      return false;
    }
  }

  Future<bool> editFlashcard(Flashcard flashcard) async {
    final collection = _flashcardCollection;
    if (collection == null) {
      _flashcards = [
        for (final card in _flashcards)
          if (card.id == flashcard.id) flashcard else card,
      ];
      notifyListeners();
      return true;
    }

    try {
      await collection.doc(flashcard.id).update(flashcard.toMap());
      await fetchFlashcards();
      return true;
    } catch (error) {
      _errorMessage = _friendlyError(error);
      notifyListeners();
      debugPrint('Error updating flashcard: $error');
      return false;
    }
  }

  Future<bool> deleteFlashcard(String id) async {
    final collection = _flashcardCollection;
    if (collection == null) {
      _flashcards = _flashcards.where((flashcard) => flashcard.id != id).toList();
      notifyListeners();
      return true;
    }

    try {
      await collection.doc(id).delete();
      _flashcards = _flashcards.where((flashcard) => flashcard.id != id).toList();
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (error) {
      _errorMessage = _friendlyError(error);
      notifyListeners();
      debugPrint('Error deleting flashcard: $error');
      return false;
    }
  }

  void clearError() {
    if (_errorMessage == null) {
      return;
    }
    _errorMessage = null;
    notifyListeners();
  }

  String _friendlyError(Object error) {
    if (error is FirebaseException) {
      if (error.code == 'unavailable') {
        return 'Unable to reach the server. Check your internet connection.';
      }
      if (error.code == 'permission-denied') {
        return 'You do not have permission to access these flashcards.';
      }
      return error.message ?? 'Something went wrong. Please try again.';
    }
    return 'Something went wrong. Please try again.';
  }
}
