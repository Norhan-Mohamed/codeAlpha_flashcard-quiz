import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/flashcard_data.dart';
import 'firebase_options.dart';
import 'screens/flashcard_list_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FlashcardQuizApp());
}

class FlashcardQuizApp extends StatelessWidget {
  const FlashcardQuizApp({
    super.key,
    this.flashcardData,
  });

  final FlashcardData? flashcardData;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final data = flashcardData ?? FlashcardData();
        if (flashcardData == null) {
          data.fetchFlashcards();
        }
        return data;
      },
      child: MaterialApp(
        title: 'Flashcard Quiz',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const FlashcardListScreen(),
      ),
    );
  }
}
