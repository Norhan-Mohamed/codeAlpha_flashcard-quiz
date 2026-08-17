import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

class FlipCard extends StatefulWidget {
  final String frontTitle;
  final String frontSubtitle;
  final String backTitle;
  final String backSubtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FlipCard({
    super.key,
    required this.frontTitle,
    required this.frontSubtitle,
    required this.backTitle,
    required this.backSubtitle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool _isFlipped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFlipped = !_isFlipped;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 520),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotate = Tween(begin: pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotate,
            builder: (BuildContext context, Widget? child) {
              final isUnder = ValueKey(_isFlipped) != child?.key;
              final value = isUnder ? min(rotate.value, pi / 2) : rotate.value;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(value),
                child: child,
              );
            },
            child: child,
          );
        },
        child: _isFlipped
            ? CardContent(
                key: const ValueKey(true),
                title: widget.backTitle,
                subtitle: widget.backSubtitle,
                gradient: AppColors.cardBack,
                titleColor: AppColors.white,
                bodyColor: AppColors.white,
                actionColor: AppColors.white,
                hint: 'Tap to flip back',
                onEdit: widget.onEdit,
                onDelete: widget.onDelete,
              )
            : CardContent(
                key: const ValueKey(false),
                title: widget.frontTitle,
                subtitle: widget.frontSubtitle,
                gradient: AppColors.cardFront,
                titleColor: AppColors.deepTeal,
                bodyColor: AppColors.ink,
                actionColor: AppColors.ink,
                hint: 'Tap to reveal answer',
                onEdit: widget.onEdit,
                onDelete: widget.onDelete,
              ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final Color titleColor;
  final Color bodyColor;
  final Color actionColor;
  final String hint;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CardContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.titleColor,
    required this.bodyColor,
    required this.actionColor,
    required this.hint,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.softBlue.withValues(alpha: 0.22),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.65),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: titleColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    title.toUpperCase(),
                    style: GoogleFonts.nunito(
                      color: titleColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.flip,
                  size: 18,
                  color: actionColor.withValues(alpha: 0.55),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              subtitle,
              style: GoogleFonts.nunito(
                color: bodyColor,
                fontSize: 20,
                height: 1.35,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              hint,
              style: GoogleFonts.nunito(
                color: bodyColor.withValues(alpha: 0.55),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Edit',
                  icon: Icon(Icons.edit_rounded, color: actionColor),
                  onPressed: onEdit,
                ),
                IconButton(
                  tooltip: 'Delete',
                  icon: Icon(Icons.delete_outline_rounded, color: actionColor),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
