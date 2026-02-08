import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

import '../services/api_service.dart';
import '../theme/app_colors.dart';
import '../theme/glass_decoration.dart';
import '../utils/page_transitions.dart';
import '../widgets/premium_loading_indicator.dart';
import 'result_screen.dart';

class LoadingScreen extends StatefulWidget {
  final File imageFile;

  const LoadingScreen({super.key, required this.imageFile});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String _statusText = 'AI가 분석 중이에요';

  @override
  void initState() {
    super.initState();
    _analyze();
  }

  Future<void> _analyze() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() => _statusText = '상품을 인식하고 있어요');
      }

      final result = await ApiService.analyzeImage(widget.imageFile);

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        FadeScaleRoute(
          page: ResultScreen(result: result),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop(e.message);
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop('예상치 못한 오류가 발생했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Image preview with gradient border frame
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.cardBorder,
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.gradientStart.withAlpha(20),
                      AppColors.gradientEnd.withAlpha(20),
                    ],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    widget.imageFile,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.03, 1.03),
                    duration: 1800.ms,
                    curve: Curves.easeInOut,
                  ),
              const SizedBox(height: 32),
              // Skeleton card
              _buildSkeletonCard()
                  .animate()
                  .fadeIn(
                    duration: 400.ms,
                    delay: 200.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .slideY(
                    begin: 0.06,
                    end: 0,
                    duration: 400.ms,
                    delay: 200.ms,
                    curve: Curves.easeOutCubic,
                  ),
              const Spacer(),
              // Premium loading indicator
              const PremiumLoadingIndicator(size: 48),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: Text(
                  _statusText,
                  key: ValueKey(_statusText),
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonCard() {
    return GlassCard(
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBase,
        highlightColor: AppColors.shimmerHighlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 160,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 200,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(
              3,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.shimmerBase,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.shimmerBase,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
