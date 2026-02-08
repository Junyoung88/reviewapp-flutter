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

class KoreaPriceInfo {
  final String availableInKorea;
  final String koreaPriceRange;
  final String priceComparison;
  final String note;

  KoreaPriceInfo({
    required this.availableInKorea,
    required this.koreaPriceRange,
    required this.priceComparison,
    required this.note,
  });

  factory KoreaPriceInfo.fromJson(Map<String, dynamic> json) {
    return KoreaPriceInfo(
      availableInKorea: json['available_in_korea'] as String,
      koreaPriceRange: json['korea_price_range'] as String,
      priceComparison: json['price_comparison'] as String,
      note: json['note'] as String,
    );
  }
}

class GiftPersonal {
  final String giftSuitability;
  final String personalSuitability;

  GiftPersonal({
    required this.giftSuitability,
    required this.personalSuitability,
  });

  factory GiftPersonal.fromJson(Map<String, dynamic> json) {
    return GiftPersonal(
      giftSuitability: json['gift_suitability'] as String,
      personalSuitability: json['personal_suitability'] as String,
    );
  }
}

class ReviewReliability {
  final String level;
  final String reason;

  ReviewReliability({required this.level, required this.reason});

  factory ReviewReliability.fromJson(Map<String, dynamic> json) {
    return ReviewReliability(
      level: json['level'] as String,
      reason: json['reason'] as String,
    );
  }
}

class ReviewSummary {
  final String oneLine;
  final double averageRating;
  final List<String> tasteTexture;
  final List<String> koreaComparison;
  final List<String> pros;
  final List<String> cons;
  final KoreaPriceInfo? koreaPriceInfo;
  final GiftPersonal? giftPersonal;
  final String recommendation;
  final ReviewReliability? reviewReliability;

  ReviewSummary({
    required this.oneLine,
    this.averageRating = 0.0,
    required this.tasteTexture,
    required this.koreaComparison,
    required this.pros,
    required this.cons,
    this.koreaPriceInfo,
    this.giftPersonal,
    required this.recommendation,
    this.reviewReliability,
  });

  factory ReviewSummary.fromJson(Map<String, dynamic> json) {
    return ReviewSummary(
      oneLine: json['one_line'] as String,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      tasteTexture: (json['taste_texture'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      koreaComparison: (json['korea_comparison'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      pros:
          (json['pros'] as List<dynamic>).map((e) => e as String).toList(),
      cons:
          (json['cons'] as List<dynamic>).map((e) => e as String).toList(),
      koreaPriceInfo: json['korea_price_info'] != null
          ? KoreaPriceInfo.fromJson(
              json['korea_price_info'] as Map<String, dynamic>)
          : null,
      giftPersonal: json['gift_personal'] != null
          ? GiftPersonal.fromJson(
              json['gift_personal'] as Map<String, dynamic>)
          : null,
      recommendation: json['recommendation'] as String,
      reviewReliability: json['review_reliability'] != null
          ? ReviewReliability.fromJson(
              json['review_reliability'] as Map<String, dynamic>)
          : null,
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
