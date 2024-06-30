import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../constant/colors.dart';
import '../data/flashcard_data.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  bool _showAnswer = false;
  final TextEditingController _controller = TextEditingController();
  List<String> _wrongAnswers = [];

  @override
  Widget build(BuildContext context) {
    final flashcards = Provider.of<FlashcardData>(context).flashcards;

    if (flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Quiz',
            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: constantColors.Black),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: constantColors.Black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                ),
              ],
            ),
            child: Center(
              child: const Text(
                'No flashcards available.',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          ),
        ),
      );
    }

    void _showResultDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Quiz Completed'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Score: $_score / ${flashcards.length}'),
                if (_wrongAnswers.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _wrongAnswers.map((answer) => Text(answer)).toList(),
                  ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Try Again'),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                    _score = 0;
                    _wrongAnswers.clear();
                    _controller.clear();
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        },
      );
    }

    void _submitAnswer() {
      setState(() {
        if (_controller.text.trim().toLowerCase() != flashcards[_currentIndex].answer.trim().toLowerCase()) {
          _wrongAnswers.add('${flashcards[_currentIndex].question} ? \n - Correct Answer: ${flashcards[_currentIndex].answer}');
        } else {
          _score++;
        }
        _controller.clear();
        if (_currentIndex < flashcards.length - 1) {
          _currentIndex++;
        } else {
          _showAnswer = false;
          _showResultDialog(context);
        }
      });
    }

    final flashcard = flashcards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quiz',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: constantColors.Black),
        ),
        centerTitle: true,
        backgroundColor: constantColors.SoftBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: constantColors.Black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                color: constantColors.SoftBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Score: $_score / ${flashcards.length}',
                        style: const TextStyle(fontSize: 24.0),
                      ),
                      SizedBox(height: 20),
                      Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                'Question ${_currentIndex + 1}',
                                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: constantColors.Black),
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                flashcard.question,
                                style: const TextStyle(fontSize: 24.0),
                              ),
                              const SizedBox(height: 20.0),
                              TextField(
                                controller: _controller,
                                decoration: const InputDecoration(
                                  labelText: 'Your Answer',
                                  labelStyle: TextStyle(color: constantColors.Black),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/2,
                        child: ElevatedButton(
                          onPressed: _submitAnswer,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),

                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          child: const Text('Submit', style: TextStyle(color: constantColors.Black)),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/2,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),

                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          onPressed: () {
                            setState(() {
                              _showAnswer = !_showAnswer;
                            });
                          },
                          child: Text(_showAnswer ? 'Hide Answer' : 'Show Answer', style: TextStyle(color: constantColors.Black)),
                        ),
                      ),
                      if (_showAnswer)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            flashcard.answer,
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                      const SizedBox(height: 50.0),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
