import 'package:flutter/material.dart';

import '../models/analysis_response.dart';

class ResultScreen extends StatelessWidget {
  final AnalysisResponse result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('분석 결과'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상품명 카드
            _buildProductCard(theme),
            const SizedBox(height: 16),
            // 한줄 요약
            _buildSummaryCard(theme),
            const SizedBox(height: 16),
            // 장점
            _buildProsCard(theme),
            const SizedBox(height: 16),
            // 단점
            _buildConsCard(theme),
            const SizedBox(height: 16),
            // 추천
            _buildRecommendationCard(theme),
            const SizedBox(height: 16),
            // OCR 정보
            _buildOcrCard(theme),
            if (result.cached) ...[
              const SizedBox(height: 12),
              Center(
                child: Text(
                  '캐시된 결과입니다',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            // 다시 분석 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).popUntil(
                  (route) => route.isFirst,
                ),
                icon: const Icon(Icons.camera_alt),
                label: const Text('다른 상품 분석하기'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_bag, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('상품 정보', style: theme.textTheme.titleMedium),
              ],
            ),
            const Divider(),
            Text(
              result.selectedProduct,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (result.productCandidates.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: result.productCandidates.map((c) {
                  return Chip(
                    label: Text(
                      '${c.name} (${(c.confidence * 100).toStringAsFixed(0)}%)',
                      style: const TextStyle(fontSize: 12),
                    ),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ThemeData theme) {
    return Card(
      elevation: 2,
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                result.reviewSummary.oneLine,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProsCard(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.thumb_up, color: Colors.green),
                const SizedBox(width: 8),
                Text('장점', style: theme.textTheme.titleMedium),
              ],
            ),
            const Divider(),
            ...result.reviewSummary.pros.map(
              (pro) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('✓ ', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    Expanded(child: Text(pro)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsCard(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.thumb_down, color: Colors.red),
                const SizedBox(width: 8),
                Text('단점', style: theme.textTheme.titleMedium),
              ],
            ),
            const Divider(),
            ...result.reviewSummary.cons.map(
              (con) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('✗ ', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    Expanded(child: Text(con)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(ThemeData theme) {
    return Card(
      elevation: 2,
      color: theme.colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.recommend, color: theme.colorScheme.tertiary),
                const SizedBox(width: 8),
                Text('추천', style: theme.textTheme.titleMedium),
              ],
            ),
            const Divider(),
            Text(
              result.reviewSummary.recommendation,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOcrCard(ThemeData theme) {
    final ocr = result.ocrResult;
    final hasOcrInfo =
        ocr.brand != null || ocr.productName != null || ocr.modelName != null;

    if (!hasOcrInfo && ocr.rawTexts.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 1,
      child: ExpansionTile(
        leading: const Icon(Icons.text_fields),
        title: const Text('OCR 인식 정보'),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ocr.brand != null)
                  _buildOcrRow('브랜드', ocr.brand!),
                if (ocr.productName != null)
                  _buildOcrRow('제품명', ocr.productName!),
                if (ocr.modelName != null)
                  _buildOcrRow('모델명', ocr.modelName!),
                if (ocr.rawTexts.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    '인식된 텍스트:',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ocr.rawTexts.join(', '),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOcrRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
