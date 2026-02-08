import 'dart:io';

import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'result_screen.dart';

class LoadingScreen extends StatefulWidget {
  final File imageFile;

  const LoadingScreen({super.key, required this.imageFile});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String _statusText = '이미지를 분석하고 있습니다...';

  @override
  void initState() {
    super.initState();
    _analyze();
  }

  Future<void> _analyze() async {
    try {
      // 상태 메시지 업데이트
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() => _statusText = '상품을 인식하고 있습니다...');
      }

      final result = await ApiService.analyzeImage(widget.imageFile);

      if (!mounted) return;

      // 결과 화면으로 이동 (로딩 화면 교체)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(result: result),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      // 에러 시 이전 화면으로 돌아가며 에러 메시지 전달
      Navigator.of(context).pop(e.message);
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop('예상치 못한 오류가 발생했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 선택한 이미지 미리보기
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  widget.imageFile,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                _statusText,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'AI가 리뷰를 분석 중입니다.\n잠시만 기다려주세요.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
