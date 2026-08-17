import 'package:flutter/material.dart';

class AppColors {
  static const Color softBlue = Color(0xFF5BC0EB);
  static const Color sky = Color(0xFF7DD3F0);
  static const Color deepTeal = Color(0xFF0E8A9A);
  static const Color mint = Color(0xFFB8F2E6);
  static const Color coral = Color(0xFFFF7A59);
  static const Color sun = Color(0xFFFFC857);
  static const Color lightGray = Color(0xFFE8EEF2);
  static const Color mist = Color(0xFFF3FAFD);
  static const Color white = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF143642);
  static const Color muted = Color(0xFF5B6B73);

  static const LinearGradient skyWash = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE8F8FF),
      Color(0xFFF5FCFF),
      Color(0xFFFFF8F1),
    ],
  );

  static const LinearGradient brandWave = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      softBlue,
      sky,
      Color(0xFF3AA8D8),
    ],
  );

  static const LinearGradient cardFront = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFEAF6FB),
    ],
  );

  static const LinearGradient cardBack = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      softBlue,
      Color(0xFF3BA8D4),
    ],
  );

  static const LinearGradient quizHero = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      softBlue,
      Color(0xFF4AB4DE),
      Color(0xFF2F9BC6),
    ],
  );
}
