import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/flashcard_form_screen.dart';
import '../data/flashcard_data.dart';
import '../models/flashcard.dart';
import 'customed-card.dart';

class FlashcardTile extends StatelessWidget {
  final Flashcard flashcard;
  final int index;

  const FlashcardTile({super.key, required this.flashcard, required this.index});

  @override
  Widget build(BuildContext context) {
    final flashcardId = Provider.of<FlashcardData>(context).flashcards[index];

    return FlipCard(
      frontTitle: 'Question',
      frontSubtitle: flashcard.question,
      backTitle: 'Answer',
      backSubtitle: flashcard.answer,
      onEdit: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlashcardFormScreen(flashcard: flashcard),
          ),
        );
      },
      onDelete: () async {
        try {
          await Provider.of<FlashcardData>(context, listen: false)
              .deleteFlashcard(flashcard.id);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Flashcard deleted successfully'),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete flashcard: $e'),
            ),
          );
        }
      },
    );
  }
}

/*
ListTile(
title: Text(flashcard.question),
subtitle: Text(flashcard.answer),
trailing: Row(
mainAxisSize: MainAxisSize.min,
children: [
IconButton(
icon: Icon(Icons.edit),
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => FlashcardFormScreen(
id: flashcardId.toString(), flashcard: flashcard),
),
);
},
),
IconButton(
icon: Icon(Icons.delete),
onPressed: () {
Provider.of<FlashcardData>(context, listen: false)
    .deleteFlashcard(flashcardId as String);
},
),
],
),
*/
