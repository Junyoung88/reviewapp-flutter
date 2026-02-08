import 'package:flutter_test/flutter_test.dart';

import 'package:product_review_ai_app/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProductReviewApp());

    expect(find.text('상품 리뷰 AI'), findsOneWidget);
    expect(find.text('상품 사진을 찍어주세요'), findsOneWidget);
  });
}
