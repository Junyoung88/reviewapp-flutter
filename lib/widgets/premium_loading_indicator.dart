import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PremiumLoadingIndicator extends StatefulWidget {
  final double size;

  const PremiumLoadingIndicator({super.key, this.size = 64});

  @override
  State<PremiumLoadingIndicator> createState() =>
      _PremiumLoadingIndicatorState();
}

class _PremiumLoadingIndicatorState extends State<PremiumLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _GradientRingPainter(
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  final double progress;

  _GradientRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const strokeWidth = 3.5;

    // Background ring (faint)
    final bgPaint = Paint()
      ..color = AppColors.shimmerBase
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    // Rotating gradient arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweepAngle = pi * 1.2;
    final startAngle = 2 * pi * progress - pi / 2;

    final gradient = SweepGradient(
      startAngle: startAngle,
      endAngle: startAngle + sweepAngle,
      colors: const [
        Color(0x0058A6FF),
        AppColors.gradientStart,
        AppColors.gradientEnd,
      ],
      stops: const [0.0, 0.3, 1.0],
      transform: GradientRotation(startAngle),
    );

    final arcPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle, false, arcPaint);

    // Bright dot at the tip
    final tipAngle = startAngle + sweepAngle;
    final tipX = center.dx + radius * cos(tipAngle);
    final tipY = center.dy + radius * sin(tipAngle);

    final glowPaint = Paint()
      ..color = AppColors.gradientEnd.withAlpha(100)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(tipX, tipY), 4, glowPaint);

    final dotPaint = Paint()..color = AppColors.gradientEnd;
    canvas.drawCircle(Offset(tipX, tipY), 2.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _GradientRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
