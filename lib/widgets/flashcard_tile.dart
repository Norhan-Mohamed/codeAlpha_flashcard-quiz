import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/flashcard_data.dart';
import '../models/flashcard.dart';
import '../screens/flashcard_form_screen.dart';
import 'flip_card.dart';

class FlashcardTile extends StatelessWidget {
  final Flashcard flashcard;

  const FlashcardTile({super.key, required this.flashcard});

  @override
  Widget build(BuildContext context) {
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
      onDelete: () => _confirmDelete(context),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete flashcard?'),
          content: const Text('This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !context.mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final success = await context.read<FlashcardData>().deleteFlashcard(flashcard.id);

    if (!context.mounted) {
      return;
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Flashcard deleted successfully'
              : 'Failed to delete flashcard. Please try again.',
        ),
      ),
    );
  }
}
