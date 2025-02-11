import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../lib/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('User Experience Tests', () {
    testWidgets('Complete drawing workflow test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 시작 화면 테스트
      expect(find.text('3D 드로잉 변환기'), findsOneWidget);
      expect(find.text('그림 그리기 시작하기'), findsOneWidget);
      // 로고 이미지 대신 아이콘 테스트
      expect(find.byIcon(Icons.draw), findsWidgets);  // 아이콘이 여러 개 있을 수 있음

      // 그리기 화면으로 이동
      await tester.tap(find.text('그림 그리기 시작하기'));
      await tester.pumpAndSettle();

      // 그리기 기능 테스트
      final center = tester.getCenter(find.byType(DrawingCanvas));
      await tester.dragFrom(center, Offset(100, 100));
      await tester.pumpAndSettle();

      // 도구 사용 테스트
      await tester.tap(find.byIcon(Icons.edit_off));
      await tester.pumpAndSettle();

      // 색상 선택 테스트
      await tester.tap(find.byType(ColorPalette).first);
      await tester.pumpAndSettle();

      // 3D 변환 테스트
      expect(find.byType(ThreeScene), findsOneWidget);
    });

    testWidgets('Responsive layout test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 가로 모드 테스트
      await tester.binding.setSurfaceSize(Size(1024, 768));
      await tester.pumpAndSettle();
      
      expect(find.byType(Row), findsOneWidget);

      // 세로 모드 테스트
      await tester.binding.setSurfaceSize(Size(768, 1024));
      await tester.pumpAndSettle();
      
      expect(find.byType(Column), findsOneWidget);
    });
  });
} 