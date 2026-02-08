import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class WaterDropButton extends StatelessWidget {
  final VoidCallback onTap;
  final double size;

  const WaterDropButton({
    super.key,
    required this.onTap,
    this.size = 72,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size * 1.18,
        child: CustomPaint(
          size: Size(size, size * 1.18),
          painter: _WaterDropPainter(),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: size * 0.1),
              child: Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: size * 0.35,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WaterDropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final path = Path();
    // Water drop: round top, pointed bottom
    path.moveTo(w * 0.5, h); // bottom point
    path.quadraticBezierTo(w * 0.0, h * 0.68, w * 0.0, h * 0.4);
    path.arcToPoint(
      Offset(w, h * 0.4),
      radius: Radius.circular(w * 0.5),
      clockwise: true,
    );
    path.quadraticBezierTo(w * 1.0, h * 0.68, w * 0.5, h);
    path.close();

    // Shadow
    canvas.drawShadow(
      path.shift(const Offset(0, 2)),
      AppColors.primaryBlue.withAlpha(100),
      12,
      true,
    );

    // Gradient fill
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.gradientStart,
          AppColors.primaryBlue,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(path, paint);

    // Glossy highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withAlpha(55)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.38, h * 0.3),
        width: w * 0.18,
        height: w * 0.12,
      ),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
