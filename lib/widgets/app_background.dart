import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    this.showDecor = true,
  });

  final Widget child;
  final bool showDecor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: AppColors.skyWash),
          ),
        ),
        if (showDecor) ...[
          Positioned(
            top: -80,
            right: -40,
            child: _Blob(
              size: 220,
              color: AppColors.softBlue.withValues(alpha: 0.22),
            ),
          ),
          Positioned(
            top: 140,
            left: -70,
            child: _Blob(
              size: 180,
              color: AppColors.mint.withValues(alpha: 0.55),
            ),
          ),
          Positioned(
            bottom: 80,
            right: -50,
            child: _Blob(
              size: 160,
              color: AppColors.sun.withValues(alpha: 0.28),
            ),
          ),
        ],
        child,
      ],
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
