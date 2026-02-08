import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/analysis_response.dart';
import '../theme/app_colors.dart';
import '../theme/glass_decoration.dart';
import '../widgets/confidence_chart.dart';
import '../widgets/scale_on_tap.dart';

class ResultScreen extends StatelessWidget {
  final AnalysisResponse result;

  const ResultScreen({super.key, required this.result});

  Widget _animatedCard(Widget child, int delayMs) {
    return child
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: Duration(milliseconds: delayMs),
          curve: Curves.easeOutCubic,
        )
        .slideY(
          begin: 0.06,
          end: 0,
          duration: 400.ms,
          delay: Duration(milliseconds: delayMs),
          curve: Curves.easeOutCubic,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).popUntil(
                      (route) => route.isFirst,
                    ),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    '분석 결과',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(
                  duration: 300.ms,
                  curve: Curves.easeOutCubic,
                ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    _animatedCard(_buildProductCard(), 100),
                    const SizedBox(height: 12),
                    _animatedCard(_buildSummaryCard(), 180),
                    const SizedBox(height: 12),
                    if (result.reviewSummary.tasteTexture.isNotEmpty) ...[
                      _animatedCard(_buildTasteTextureCard(), 260),
                      const SizedBox(height: 12),
                    ],
                    if (result.reviewSummary.koreaComparison.isNotEmpty) ...[
                      _animatedCard(_buildKoreaComparisonCard(), 340),
                      const SizedBox(height: 12),
                    ],
                    _animatedCard(_buildReviewAnalysisCard(), 420),
                    const SizedBox(height: 12),
                    _animatedCard(_buildProsCard(), 500),
                    const SizedBox(height: 12),
                    _animatedCard(_buildConsCard(), 580),
                    const SizedBox(height: 12),
                    _animatedCard(_buildBuyingGuideCard(), 660),
                    const SizedBox(height: 12),
                    _animatedCard(_buildReliabilityBadge(), 740),
                    const SizedBox(height: 12),
                    _animatedCard(_buildOcrCard(), 820),
                    if (result.cached) ...[
                      const SizedBox(height: 12),
                      const Text(
                        '캐시된 결과입니다',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
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
                            onPressed: () => Navigator.of(context).popUntil(
                              (route) => route.isFirst,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              '다른 상품 분석하기',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(
                          duration: 400.ms,
                          delay: 900.ms,
                          curve: Curves.easeOutCubic,
                        )
                        .slideY(
                          begin: 0.06,
                          end: 0,
                          duration: 400.ms,
                          delay: 900.ms,
                          curve: Curves.easeOutCubic,
                        ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📦 상품 정보',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            result.selectedProduct,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (result.productCandidates.isNotEmpty) ...[
            const SizedBox(height: 16),
            ConfidenceChart(candidates: result.productCandidates),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return GlassCard(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.gradientStart.withAlpha(20),
          AppColors.gradientEnd.withAlpha(20),
        ],
      ),
      borderColor: AppColors.gradientStart.withAlpha(30),
      child: Text(
        result.reviewSummary.oneLine,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBlue,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildTasteTextureCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🍽 맛 / 사용감 특징',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          ...result.reviewSummary.tasteTexture.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKoreaComparisonCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🇰🇷 한국 제품 대비 차이',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          ...result.reviewSummary.koreaComparison.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: AppColors.gradientEnd,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewAnalysisCard() {
    final rating = result.reviewSummary.averageRating;
    return GlassCard(
      child: Row(
        children: [
          const Text(
            '📊 평균 평점',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          _buildStarRow(rating),
          const SizedBox(width: 10),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            ),
          ),
          const Text(
            ' / 5.0',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRow(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return const Icon(Icons.star_rounded,
              size: 20, color: Color(0xFFFFB800));
        } else if (i < rating) {
          return const Icon(Icons.star_half_rounded,
              size: 20, color: Color(0xFFFFB800));
        }
        return Icon(Icons.star_rounded,
            size: 20, color: Colors.grey.withAlpha(60));
      }),
    );
  }

  Widget _buildProsCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('👍 장점',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          ...result.reviewSummary.pros.map(
            (pro) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 3,
                      decoration: BoxDecoration(
                        color: AppColors.prosGreen,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(pro,
                          style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                              height: 1.4)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsCard() {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('👎 단점',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          ...result.reviewSummary.cons.map(
            (con) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 3,
                      decoration: BoxDecoration(
                        color: AppColors.consRed,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(con,
                          style: const TextStyle(
                              fontSize: 15,
                              color: AppColors.textPrimary,
                              height: 1.4)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuyingGuideCard() {
    final priceInfo = result.reviewSummary.koreaPriceInfo;
    final gp = result.reviewSummary.giftPersonal;
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🛒 구매 가이드',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          if (priceInfo != null) ...[
            _buildInfoRow('한국 판매', priceInfo.availableInKorea),
            _buildInfoRow('한국 가격대', priceInfo.koreaPriceRange),
            _buildInfoRow('가격 비교', priceInfo.priceComparison),
            if (priceInfo.note.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(priceInfo.note,
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.4)),
              ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.cardBorder),
            const SizedBox(height: 16),
          ],
          if (gp != null) ...[
            _buildSuitabilityLine('🎁 선물용', gp.giftSuitability),
            const SizedBox(height: 8),
            _buildSuitabilityLine('🙋 개인용', gp.personalSuitability),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.cardBorder),
            const SizedBox(height: 16),
          ],
          const Text('💡 추천',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text(result.reviewSummary.recommendation,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryBlue,
                  height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _buildSuitabilityLine(String label, String suitability) {
    // Parse "높음 — 이유" format
    String rating = suitability;
    String reason = '';
    final dashIdx = suitability.indexOf('—');
    if (dashIdx != -1) {
      rating = suitability.substring(0, dashIdx).trim();
      reason = suitability.substring(dashIdx + 1).trim();
    }
    final color = rating == '높음'
        ? AppColors.prosGreen
        : rating == '낮음'
            ? AppColors.consRed
            : AppColors.textSecondary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(rating,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: color)),
        ),
        if (reason.isNotEmpty) ...[
          const SizedBox(width: 8),
          Expanded(
            child: Text(reason,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4)),
          ),
        ],
      ],
    );
  }

  Widget _buildReliabilityBadge() {
    final rel = result.reviewSummary.reviewReliability;
    if (rel == null) return const SizedBox.shrink();
    final color = switch (rel.level) {
      '높음' => AppColors.prosGreen,
      '중간' => const Color(0xFFFF9500),
      _ => AppColors.consRed,
    };
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          const Text('📋 리뷰 신뢰도',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withAlpha(60)),
            ),
            child: Text(rel.level,
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: color)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(rel.reason,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildOcrCard() {
    final ocr = result.ocrResult;
    final hasOcrInfo =
        ocr.brand != null || ocr.productName != null || ocr.modelName != null;
    if (!hasOcrInfo && ocr.rawTexts.isEmpty) return const SizedBox.shrink();
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          iconColor: AppColors.textSecondary,
          collapsedIconColor: AppColors.textSecondary,
          title: const Text('🔍 OCR 인식 정보',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary)),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ocr.brand != null) _buildOcrRow('브랜드', ocr.brand!),
                if (ocr.productName != null)
                  _buildOcrRow('제품명', ocr.productName!),
                if (ocr.modelName != null) _buildOcrRow('모델명', ocr.modelName!),
                if (ocr.rawTexts.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  const Text('인식된 텍스트',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(ocr.rawTexts.join(', '),
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textPrimary)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOcrRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
