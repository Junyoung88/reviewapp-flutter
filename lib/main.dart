import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const ProductReviewApp());
}

class ProductReviewApp extends StatelessWidget {
  const ProductReviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '상품 리뷰 AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
