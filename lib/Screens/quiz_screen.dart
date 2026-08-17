import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/flashcard_data.dart';
import '../models/flashcard.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _wrongAnswers = [];

  List<Flashcard> _quizCards = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _showAnswer = false;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final cards = context.read<FlashcardData>().flashcards;
      setState(() {
        if (cards.isNotEmpty) {
          _startQuiz(cards);
        }
        _ready = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startQuiz(List<Flashcard> source) {
    _quizCards = List<Flashcard>.from(source)..shuffle(Random());
    _currentIndex = 0;
    _score = 0;
    _showAnswer = false;
    _wrongAnswers.clear();
    _controller.clear();
  }

  void _submitAnswer() {
    if (_quizCards.isEmpty) {
      return;
    }

    final current = _quizCards[_currentIndex];
    final isCorrect = _controller.text.trim().toLowerCase() ==
        current.answer.trim().toLowerCase();

    setState(() {
      if (isCorrect) {
        _score++;
      } else {
        _wrongAnswers.add(
          '${current.question}\nCorrect answer: ${current.answer}',
        );
      }

      _controller.clear();
      _showAnswer = false;

      if (_currentIndex < _quizCards.length - 1) {
        _currentIndex++;
      } else {
        _showResultDialog();
      }
    });
  }

  void _showResultDialog() {
    final perfect = _score == _quizCards.length;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(perfect ? 'Perfect run!' : 'Quiz completed'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: perfect ? AppColors.brandWave : null,
                    color: perfect ? null : AppColors.mint.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Score: $_score / ${_quizCards.length}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredoka(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: perfect ? AppColors.white : AppColors.ink,
                    ),
                  ),
                ),
                if (_wrongAnswers.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Review',
                    style: GoogleFonts.nunito(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  ..._wrongAnswers.map(
                    (answer) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        answer,
                        style: GoogleFonts.nunito(height: 1.35),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _startQuiz(context.read<FlashcardData>().flashcards);
                });
              },
              child: const Text('Try again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final flashcards = context.watch<FlashcardData>().flashcards;

    if (!_ready) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const AppBackground(
          child: Center(
            child: CircularProgressIndicator(color: AppColors.softBlue),
          ),
        ),
      );
    }

    if (flashcards.isEmpty || _quizCards.isEmpty) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(title: const Text('Quiz')),
        body: AppBackground(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Text(
                'No flashcards available. Add some cards first, then come back to quiz.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
            ),
          ),
        ),
      );
    }

    final flashcard = _quizCards[_currentIndex];
    final progress = (_currentIndex + 1) / _quizCards.length;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: AppBackground(
        showDecor: false,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 260,
                decoration: const BoxDecoration(
                  gradient: AppColors.quizHero,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(42),
                    bottomRight: Radius.circular(42),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: AppColors.white.withValues(alpha: 0.35),
                        color: AppColors.sun,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _StatChip(
                            label: 'Score',
                            value: '$_score / ${_quizCards.length}',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _StatChip(
                            label: 'Card',
                            value: '${_currentIndex + 1} / ${_quizCards.length}',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        child: SingleChildScrollView(
                          key: ValueKey(_currentIndex),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.ink.withValues(alpha: 0.12),
                                  blurRadius: 24,
                                  offset: const Offset(0, 14),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'QUESTION',
                                  style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                    color: AppColors.deepTeal,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  flashcard.question,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 26,
                                    height: 1.3,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                TextField(
                                  controller: _controller,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) => _submitAnswer(),
                                  style: GoogleFonts.nunito(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Your answer',
                                    filled: true,
                                    fillColor: AppColors.mist,
                                    prefixIcon: const Icon(Icons.edit_note_rounded),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 220),
                                  child: _showAnswer
                                      ? Padding(
                                          padding: const EdgeInsets.only(top: 18),
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(14),
                                            decoration: BoxDecoration(
                                              color: AppColors.mint.withValues(alpha: 0.55),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              'Answer: ${flashcard.answer}',
                                              style: GoogleFonts.nunito(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.ink,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitAnswer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.coral,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Submit'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _showAnswer = !_showAnswer;
                          });
                        },
                        child: Text(_showAnswer ? 'Hide answer' : 'Show answer'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.nunito(
              color: AppColors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.fredoka(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
