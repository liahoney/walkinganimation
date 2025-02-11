import 'package:flutter/material.dart' hide Colors;
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import '../../viewmodels/three_viewmodel.dart';
import 'dart:math' as math;

class ThreeScene extends StatefulWidget {
  const ThreeScene({super.key});

  @override
  State<ThreeScene> createState() => _ThreeSceneState();
}

class _ThreeSceneState extends State<ThreeScene> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThreeViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          onScaleUpdate: (details) {
            // scale과 rotation을 모두 처리
            if (details.scale != 1.0) {
              // 확대/축소
              viewModel.setScale(details.scale);
            } else {
              // 회전 (이전의 pan 동작)
              viewModel.rotate(vector_math.Vector3(
                details.focalPointDelta.dy * 0.01,
                -details.focalPointDelta.dx * 0.01,
                0,
              ));
            }
          },
          child: CustomPaint(
            painter: ThreePainter(
              vertices: viewModel.vertices,
              indices: viewModel.indices,
              normals: viewModel.normals,
              colors: viewModel.colors,
              rotation: viewModel.rotation,
              scale: viewModel.scale,
              lightPosition: viewModel.lightPosition,
              lightColor: viewModel.lightColor,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class ThreePainter extends CustomPainter {
  final List<vector_math.Vector3> vertices;
  final List<int> indices;
  final List<vector_math.Vector3> normals;
  final List<vector_math.Vector3> colors;
  final vector_math.Vector3 rotation;
  final double scale;
  final vector_math.Vector3 lightPosition;
  final vector_math.Vector3 lightColor;

  ThreePainter({
    required this.vertices,
    required this.indices,
    required this.normals,
    required this.colors,
    required this.rotation,
    required this.scale,
    required this.lightPosition,
    required this.lightColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color.fromRGBO(128, 128, 128, 1);

    // 뷰포트 중앙으로 이동
    canvas.translate(size.width / 2, size.height / 2);
    
    // 스케일 적용
    canvas.scale(scale);

    // 회전 적용
    final rotationMatrix = vector_math.Matrix4.rotationX(rotation.x)
      ..rotateY(rotation.y)
      ..rotateZ(rotation.z);

    // 삼각형 그리기
    for (int i = 0; i < indices.length; i += 3) {
      final v1 = vertices[indices[i]];
      final v2 = vertices[indices[i + 1]];
      final v3 = vertices[indices[i + 2]];
      final normal = normals[i ~/ 3];

      // 회전 적용
      final transformedV1 = rotationMatrix.transform3(v1);
      final transformedV2 = rotationMatrix.transform3(v2);
      final transformedV3 = rotationMatrix.transform3(v3);
      final transformedNormal = rotationMatrix.transform3(normal);

      // 조명 계산
      final lightDir = (lightPosition - transformedV1).normalized();
      final diffuse = math.max(0, lightDir.dot(transformedNormal));
      
      // 현재 면의 색상 사용
      final faceColor = colors[i ~/ 3];
      final color = Color.fromRGBO(
        (faceColor.x * lightColor.x * diffuse * 255).toInt(),
        (faceColor.y * lightColor.y * diffuse * 255).toInt(),
        (faceColor.z * lightColor.z * diffuse * 255).toInt(),
        1,
      );

      // 삼각형 그리기
      final path = Path()
        ..moveTo(transformedV1.x, transformedV1.y)
        ..lineTo(transformedV2.x, transformedV2.y)
        ..lineTo(transformedV3.x, transformedV3.y)
        ..close();

      paint.color = color;
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(ThreePainter oldDelegate) {
    return oldDelegate.vertices != vertices ||
        oldDelegate.rotation != rotation ||
        oldDelegate.scale != scale;
  }
} 