import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../data/flashcard_data.dart';
import '../theme/app_colors.dart';
import '../widgets/app_background.dart';
import '../widgets/flashcard_tile.dart';
import 'flashcard_form_screen.dart';
import 'quiz_screen.dart';

class FlashcardListScreen extends StatelessWidget {
  const FlashcardListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Flashcard Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton.filledTonal(
              tooltip: 'Start quiz',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.white.withValues(alpha: 0.75),
                foregroundColor: AppColors.deepTeal,
              ),
              icon: const Icon(Icons.quiz_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: AppBackground(
        child: SafeArea(
          child: Consumer<FlashcardData>(
            builder: (context, flashcardData, child) {
              if (flashcardData.isLoading && flashcardData.flashcards.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.softBlue),
                );
              }

              if (flashcardData.hasError && flashcardData.flashcards.isEmpty) {
                return _MessageState(
                  icon: Icons.cloud_off_rounded,
                  title: 'Could not load flashcards',
                  message: flashcardData.errorMessage ?? 'Please try again.',
                  actionLabel: 'Retry',
                  onAction: flashcardData.fetchFlashcards,
                );
              }

              if (flashcardData.isEmpty) {
                return const _MessageState(
                  icon: Icons.auto_awesome_rounded,
                  title: 'Start your deck',
                  message:
                      'Create your first flashcard, flip to study, then challenge yourself in quiz mode.',
                );
              }

              return RefreshIndicator(
                color: AppColors.deepTeal,
                onRefresh: flashcardData.fetchFlashcards,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your deck',
                              style: GoogleFonts.fredoka(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${flashcardData.flashcards.length} cards ready to flip',
                              style: GoogleFonts.nunito(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.muted,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: AppColors.brandWave,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.softBlue.withValues(alpha: 0.35),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.touch_app_rounded,
                                    color: AppColors.white,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Tap a card to flip between question and answer',
                                      style: GoogleFonts.nunito(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        height: 1.35,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 8, bottom: 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0, end: 1),
                              duration: Duration(milliseconds: 280 + (index * 40).clamp(0, 240)),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 16 * (1 - value)),
                                    child: child,
                                  ),
                                );
                              },
                              child: FlashcardTile(
                                flashcard: flashcardData.flashcards[index],
                              ),
                            );
                          },
                          childCount: flashcardData.flashcards.length,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FlashcardFormScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'Add card',
          style: GoogleFonts.nunito(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: AppColors.brandWave,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.softBlue.withValues(alpha: 0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(icon, size: 44, color: AppColors.white),
            ),
            const SizedBox(height: 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                fontSize: 15,
                color: AppColors.muted,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
