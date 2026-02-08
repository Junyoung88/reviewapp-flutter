class ProductCandidate {
  final String name;
  final double confidence;

  ProductCandidate({required this.name, required this.confidence});

  factory ProductCandidate.fromJson(Map<String, dynamic> json) {
    return ProductCandidate(
      name: json['name'] as String,
      confidence: (json['confidence'] as num).toDouble(),
    );
  }
}

class OCRResult {
  final String? brand;
  final String? productName;
  final String? modelName;
  final List<String> rawTexts;

  OCRResult({
    this.brand,
    this.productName,
    this.modelName,
    this.rawTexts = const [],
  });

  factory OCRResult.fromJson(Map<String, dynamic> json) {
    return OCRResult(
      brand: json['brand'] as String?,
      productName: json['product_name'] as String?,
      modelName: json['model_name'] as String?,
      rawTexts: (json['raw_texts'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }
}

class ReviewSummary {
  final String oneLine;
  final List<String> pros;
  final List<String> cons;
  final String recommendation;

  ReviewSummary({
    required this.oneLine,
    required this.pros,
    required this.cons,
    required this.recommendation,
  });

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    return ReviewSummary(
      oneLine: json['one_line'] as String,
      pros:
          (json['pros'] as List<dynamic>).map((e) => e as String).toList(),
      cons:
          (json['cons'] as List<dynamic>).map((e) => e as String).toList(),
      recommendation: json['recommendation'] as String,
    );
  }
}

class AnalysisResponse {
  final List<ProductCandidate> productCandidates;
  final String selectedProduct;
  final OCRResult ocrResult;
  final ReviewSummary reviewSummary;
  final bool cached;

  AnalysisResponse({
    required this.productCandidates,
    required this.selectedProduct,
    required this.ocrResult,
    required this.reviewSummary,
    this.cached = false,
  });

  factory AnalysisResponse.fromJson(Map<String, dynamic> json) {
    return AnalysisResponse(
      productCandidates: (json['product_candidates'] as List<dynamic>)
          .map((e) => ProductCandidate.fromJson(e as Map<String, dynamic>))
          .toList(),
      selectedProduct: json['selected_product'] as String,
      ocrResult:
          OCRResult.fromJson(json['ocr_result'] as Map<String, dynamic>),
      reviewSummary: ReviewSummary.fromJson(
          json['review_summary'] as Map<String, dynamic>),
      cached: json['cached'] as bool? ?? false,
    );
  }
}
