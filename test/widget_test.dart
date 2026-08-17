import 'package:flashcardquizapp/data/flashcard_data.dart';
import 'package:flashcardquizapp/main.dart';
import 'package:flashcardquizapp/models/flashcard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Flashcard.toMap stores question and answer', () {
    const card = Flashcard(
      id: '1',
      question: 'Capital of France?',
      answer: 'Paris',
    );

    expect(card.toMap(), {
      'question': 'Capital of France?',
      'answer': 'Paris',
    });
  });

  testWidgets('shows empty state when there are no flashcards', (tester) async {
    await tester.pumpWidget(
      FlashcardQuizApp(
        flashcardData: FlashcardData.forTesting(),
      ),
    );

    expect(find.text('Start your deck'), findsOneWidget);
    expect(find.textContaining('Create your first flashcard'), findsOneWidget);
  });

  testWidgets('shows flashcard question on the list', (tester) async {
    await tester.pumpWidget(
      FlashcardQuizApp(
        flashcardData: FlashcardData.forTesting(
          flashcards: const [
            Flashcard(
              id: '1',
              question: 'What is 2 + 2?',
              answer: '4',
            ),
          ],
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('What is 2 + 2?'), findsOneWidget);
    expect(find.text('QUESTION'), findsWidgets);
  });
}
