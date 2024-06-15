import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/flashcard_data.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final flashcards = Provider.of<FlashcardData>(context).flashcards;

    if (flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
        ),
        body: Center(
          child: Text('No flashcards available.'),
        ),
      );
    }

    final flashcard = flashcards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              flashcard.question,
              style: TextStyle(fontSize: 24.0),
            ),
            if (_showAnswer)
              Text(
                flashcard.answer,
                style: TextStyle(fontSize: 20.0),
              ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showAnswer = !_showAnswer;
                    });
                  },
                  child: Text(_showAnswer ? 'Hide Answer' : 'Show Answer'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _score++;
                      _currentIndex = (_currentIndex + 1) % flashcards.length;
                      _showAnswer = false;
                    });
                  },
                  child: Text('Correct'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = (_currentIndex + 1) % flashcards.length;
                      _showAnswer = false;
                    });
                  },
                  child: Text('Incorrect'),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'Score: $_score',
              style: TextStyle(fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }
}
