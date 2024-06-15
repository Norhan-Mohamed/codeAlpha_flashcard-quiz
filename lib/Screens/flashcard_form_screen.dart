import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/flashcard_data.dart';
import '../models/flashcard.dart';

class FlashcardFormScreen extends StatefulWidget {
  final Flashcard? flashcard;

  FlashcardFormScreen({this.flashcard});

  @override
  _FlashcardFormScreenState createState() => _FlashcardFormScreenState();
}

class _FlashcardFormScreenState extends State<FlashcardFormScreen> {
  late TextEditingController _questionController;
  late TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(
      text: widget.flashcard?.question ?? '',
    );
    _answerController = TextEditingController(
      text: widget.flashcard?.answer ?? '',
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.flashcard == null ? 'Add Flashcard' : 'Edit Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(labelText: 'Answer'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                if (widget.flashcard == null) {
                  final newFlashcard = Flashcard(
                    id: '', // Firebase will generate the ID
                    question: _questionController.text,
                    answer: _answerController.text,
                  );
                  await Provider.of<FlashcardData>(context, listen: false)
                      .addFlashcard(newFlashcard);
                } else {
                  final updatedFlashcard = Flashcard(
                    id: widget.flashcard!.id,
                    question: _questionController.text,
                    answer: _answerController.text,
                  );
                  await Provider.of<FlashcardData>(context, listen: false)
                      .editFlashcard(updatedFlashcard);
                }
                Navigator.pop(context);
              },
              child: Text(widget.flashcard == null
                  ? 'Add Flashcard'
                  : 'Update Flashcard'),
            ),
          ],
        ),
      ),
    );
  }
}
