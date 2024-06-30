import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/colors.dart';
import '../data/flashcard_data.dart';
import '../widgets/flashcard_tile.dart';
import 'flashcard_form_screen.dart';
import 'quiz_screen.dart';

class FlashcardListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flashcards',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
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
  floatingActionButton: Container(
    decoration: BoxDecoration(
    shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5), // Darker shadow color
          spreadRadius: 3,
          blurRadius: 10,
          offset: Offset(0, 5), // Shadow position
        ),
      ],
    ),
    child: FloatingActionButton(
    backgroundColor: constantColors.SoftBlue,
    foregroundColor: constantColors.Black,
    child: Icon(Icons.add),
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => FlashcardFormScreen()),
    );
    },
    ),
    ),

    );
  }
}
