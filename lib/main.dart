import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const ProductReviewApp());
}

class ProductReviewApp extends StatelessWidget {
  const ProductReviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.notoSansTextTheme();

    return MaterialApp(
      title: '상품 리뷰 AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.scaffoldBg,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryBlue,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: AppColors.textPrimary,
          outline: AppColors.cardBorder,
        ),
        textTheme: textTheme.copyWith(
          headlineSmall: textTheme.headlineSmall?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
          bodyLarge: textTheme.bodyLarge?.copyWith(
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
          bodyMedium: textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            color: AppColors.textPrimary,
          ),
          bodySmall: textTheme.bodySmall?.copyWith(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
          titleMedium: textTheme.titleMedium?.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        splashFactory: InkSparkle.splashFactory,
      ),
      home: const HomeScreen(),
    );
  }
}
