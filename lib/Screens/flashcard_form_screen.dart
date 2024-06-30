import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/colors.dart';
import '../data/flashcard_data.dart';
import '../models/flashcard.dart';

class FlashcardFormScreen extends StatefulWidget {
  final Flashcard? flashcard;

  const FlashcardFormScreen({super.key, this.flashcard});

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
        elevation: 1,
        title:
            Text(widget.flashcard == null ? 'Add Flashcard' : 'Edit Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: constantColors.SoftBlue),
                ),
                filled: true,
                fillColor: Colors.blue.shade50,
              ),
            ),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: _answerController,
              decoration: InputDecoration(
                labelText: 'Answer',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: constantColors.SoftBlue),
                ),
                filled: true,
                fillColor: Colors.blue.shade50,
              ),
            ),
            const SizedBox(height: 20.0),
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
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(
                    color: constantColors.Black,
                    width: 1.0, // Adjust the width to make the border thin
                  ),
                ),
              ),
              child: Text(
                widget.flashcard == null ? 'Add Flashcard' : 'Update Flashcard',
                style: const TextStyle(color: constantColors.Black),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
