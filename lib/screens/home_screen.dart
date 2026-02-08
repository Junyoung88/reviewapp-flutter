import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_colors.dart';
import '../utils/page_transitions.dart';
import '../widgets/scale_on_tap.dart';
import 'loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) return;
      if (!mounted) return;

      final imageFile = File(pickedFile.path);

      final errorMessage = await Navigator.of(context).push<String>(
        SlideUpFadeRoute(
          page: LoadingScreen(imageFile: imageFile),
        ),
      );

      if (errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppColors.consRed,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: '확인',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('이미지를 가져올 수 없습니다: $e'),
          backgroundColor: AppColors.consRed,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              // Emoji with soft radial glow
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primaryBlue.withAlpha(30),
                          AppColors.gradientEnd.withAlpha(10),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  const Text(
                    '📦',
                    style: TextStyle(fontSize: 64),
                  ),
                ],
              )
                  .animate()
                  .fadeIn(
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  )
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: 20),
              // Title
              const Text(
                '상품을 찍어보세요',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: 400.ms,
                    delay: 150.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .slideY(
                    begin: 0.15,
                    end: 0,
                    duration: 400.ms,
                    delay: 150.ms,
                    curve: Curves.easeOutCubic,
                  ),
              const SizedBox(height: 12),
              // Subtitle
              const Text(
                'AI가 상품을 인식하고\n리뷰를 요약해 드려요',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(
                    duration: 400.ms,
                    delay: 300.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .slideY(
                    begin: 0.15,
                    end: 0,
                    duration: 400.ms,
                    delay: 300.ms,
                    curve: Curves.easeOutCubic,
                  ),
              const Spacer(flex: 3),
              // Camera button: gradient
              ScaleOnTap(
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.gradientStart,
                          AppColors.gradientEnd,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt_rounded, size: 22),
                          SizedBox(width: 8),
                          Text(
                            '카메라로 촬영',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: 400.ms,
                    delay: 500.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .slideY(
                    begin: 0.15,
                    end: 0,
                    duration: 400.ms,
                    delay: 500.ms,
                    curve: Curves.easeOutCubic,
                  ),
              const SizedBox(height: 12),
              // Gallery button: glass style
              ScaleOnTap(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(
                            color: AppColors.cardBorder,
                          ),
                          backgroundColor: AppColors.cardBg,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_library_rounded,
                                size: 22, color: AppColors.textSecondary),
                            SizedBox(width: 8),
                            Text(
                              '갤러리에서 선택',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(
                    duration: 400.ms,
                    delay: 600.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .slideY(
                    begin: 0.15,
                    end: 0,
                    duration: 400.ms,
                    delay: 600.ms,
                    curve: Curves.easeOutCubic,
                  ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
