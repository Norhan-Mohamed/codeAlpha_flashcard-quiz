import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/flashcard_data.dart';
import '../widgets/flashcard_tile.dart';
import 'flashcard_form_screen.dart';
import 'quiz_screen.dart';

class FlashcardListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards'),
        actions: [
          IconButton(
            icon: Icon(Icons.quiz),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<FlashcardData>(
        builder: (context, flashcardData, child) {
          final flashcards = flashcardData.flashcards;
          return ListView.builder(
            itemCount: flashcards.length,
            itemBuilder: (context, index) {
              final flashcard = flashcards[index];
              return FlashcardTile(
                flashcard: flashcard,
                index: index,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FlashcardFormScreen()),
          );
        },
      ),
    );
  }
}
