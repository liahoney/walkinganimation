import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../lib/views/drawing_view.dart';

void main() {
  group('Platform Compatibility Tests', () {
    testWidgets('Web platform rendering test', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.web;
      
      await tester.pumpWidget(
        MaterialApp(
          home: DrawingView(),
        ),
      );
      
      expect(find.byType(DrawingCanvas), findsOneWidget);
      expect(find.byType(ThreeScene), findsOneWidget);
      
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('Mobile platform rendering test', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      
      await tester.pumpWidget(
        MaterialApp(
          home: DrawingView(),
        ),
      );
      
      expect(find.byType(DrawingCanvas), findsOneWidget);
      expect(find.byType(ThreeScene), findsOneWidget);
      
      debugDefaultTargetPlatformOverride = null;
    });
  });
} 