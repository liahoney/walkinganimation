import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../lib/views/drawing_view.dart';
import '../lib/viewmodels/drawing_viewmodel.dart';
import '../lib/models/drawing_model.dart';

void main() {
  group('Performance Tests', () {
    testWidgets('Drawing performance test', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DrawingView(),
        ),
      );

      // 드로잉 성능 테스트
      final Stopwatch stopwatch = Stopwatch()..start();
      
      // 100개의 점을 연속으로 그리기
      for (int i = 0; i < 100; i++) {
        await tester.dragFrom(
          Offset(i.toDouble(), 100),
          Offset(i.toDouble() + 1, 100),
        );
        await tester.pump();
      }
      
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds < 1000, true);
    });

    test('3D conversion performance test', () {
      final viewModel = DrawingViewModel();
      final points = List.generate(
        1000,
        (i) => DrawingPoint(
          offset: Offset(i.toDouble(), 100),
          paint: Paint()..color = Colors.black,
        ),
      );

      final Stopwatch stopwatch = Stopwatch()..start();
      viewModel.convertFromDrawing(points);
      stopwatch.stop();
      
      expect(stopwatch.elapsedMilliseconds < 500, true);
    });
  });
} 