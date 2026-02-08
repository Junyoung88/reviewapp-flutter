import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ProsConsRatioBar extends StatelessWidget {
  final int prosCount;
  final int consCount;

  const ProsConsRatioBar({
    super.key,
    required this.prosCount,
    required this.consCount,
  });

  @override
  Widget build(BuildContext context) {
    final total = prosCount + consCount;
    if (total == 0) return const SizedBox.shrink();

    final prosRatio = prosCount / total;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: prosRatio),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Column(
          children: [
            Row(
              children: [
                Text(
                  '장점 ${(value * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.prosGreen,
                  ),
                ),
                const Spacer(),
                Text(
                  '단점 ${((1 - value) * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.consRed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                height: 8,
                child: Row(
                  children: [
                    Expanded(
                      flex: (value * 1000).toInt().clamp(1, 999),
                      child: Container(color: AppColors.prosGreen),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      flex: ((1 - value) * 1000).toInt().clamp(1, 999),
                      child: Container(color: AppColors.consRed),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
