import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/analysis_response.dart';

class ApiService {
  // 에뮬레이터: 10.0.2.2, 실기기: LAN IP로 변경
  static const String baseUrl = 'http://192.168.0.249:8000';
  static const Duration timeout = Duration(seconds: 120);

  /// 서버 상태 확인
  static Future<bool> healthCheck() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/api/v1/health'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// 이미지 분석 요청
  static Future<AnalysisResponse> analyzeImage(File imageFile) async {
    final uri = Uri.parse('$baseUrl/api/v1/analyze');

    // 파일 확장자로 MIME 타입 결정
    final ext = imageFile.path.split('.').last.toLowerCase();
    final mimeType = switch (ext) {
      'jpg' || 'jpeg' => MediaType('image', 'jpeg'),
      'png' => MediaType('image', 'png'),
      'webp' => MediaType('image', 'webp'),
      'heic' || 'heif' => MediaType('image', 'heic'),
      _ => MediaType('image', 'jpeg'),
    };

    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: mimeType,
        ),
      );

    final http.StreamedResponse streamedResponse;
    try {
      streamedResponse = await request.send().timeout(timeout);
    } on SocketException {
      throw ApiException('서버에 연결할 수 없습니다.\n서버가 실행 중인지 확인해주세요.');
    } on HttpException {
      throw ApiException('네트워크 오류가 발생했습니다.');
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw ApiException('요청 시간이 초과되었습니다.\n네트워크 상태를 확인해주세요.');
      }
      throw ApiException('알 수 없는 오류: $e');
    }

    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode == 200) {
      final json = jsonDecode(responseBody) as Map<String, dynamic>;
      return AnalysisResponse.fromJson(json);
    } else {
      // 서버 에러 응답 파싱
      try {
        final json = jsonDecode(responseBody) as Map<String, dynamic>;
        final error = json['error'] ?? json['detail'] ?? '서버 오류';
        throw ApiException('분석 실패: $error');
      } catch (e) {
        if (e is ApiException) rethrow;
        throw ApiException(
            '서버 오류 (${streamedResponse.statusCode})');
      }
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}
