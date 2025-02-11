import 'package:vector_math/vector_math_64.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'drawing_model.dart';
import 'shape_recognizer.dart';

class ThreeModel {
  List<Vector3> vertices = [];
  List<Vector3> normals = [];
  List<int> indices = [];
  List<Vector3> colors = [];  // 각 면의 색상을 저장할 리스트 추가
  Vector3 rotation = Vector3.zero();
  double scale = 1.0;
  
  Vector3 lightPosition = Vector3(100.0, 100.0, 100.0);
  Vector3 lightColor = Vector3(1.0, 1.0, 1.0);
  Vector3 baseColor = Vector3(0.7, 0.7, 0.7);
  
  void convertFromDrawing(List<DrawingPath> paths) {
    print('3D 변환 시작: ${paths.length} 경로');  // 디버그 로그 추가
    
    vertices.clear();
    normals.clear();
    indices.clear();
    colors.clear();

    for (final path in paths) {
      final shapeType = ShapeRecognizer.recognizeShape(path.points);
      print('인식된 도형 타입: $shapeType');  // 디버그 로그 추가
      
      switch (shapeType) {
        case ShapeType.circle:
          print('구 생성 시작');  // 디버그 로그 추가
          _createSphere(path);
          break;
        case ShapeType.rectangle:
          _createCuboid(path);
          break;
        case ShapeType.triangle:
          _createCone(path);
          break;
        case ShapeType.curve:
          _createExtrudedCurve(path);
          break;
        case ShapeType.line:
          _createExtrudedLine(path);
          break;
      }
    }

    _calculateNormals();
    print('변환 완료: ${vertices.length} 정점, ${indices.length} 인덱스');  // 디버그 로그 추가
  }

  void _createSphere(DrawingPath path) {
    final center = ShapeRecognizer.calculateCenter(path.points);
    final radius = ShapeRecognizer.calculateAverageRadius(path.points, center) * 0.5;
    
    // 구의 해상도 설정
    const latitudeBands = 16;
    const longitudeBands = 16;
    
    // 색상 설정
    final color = Vector3(
      path.points.first.paint.color.red / 255,
      path.points.first.paint.color.green / 255,
      path.points.first.paint.color.blue / 255,
    );

    // 정점 생성
    final baseIndex = vertices.length;
    for (int lat = 0; lat <= latitudeBands; lat++) {
      final theta = lat * math.pi / latitudeBands;
      final sinTheta = math.sin(theta);
      final cosTheta = math.cos(theta);

      for (int long = 0; long <= longitudeBands; long++) {
        final phi = long * 2 * math.pi / longitudeBands;
        final sinPhi = math.sin(phi);
        final cosPhi = math.cos(phi);

        final x = center.dx + radius * cosPhi * sinTheta;
        final y = center.dy + radius * sinPhi * sinTheta;
        final z = radius * cosTheta;

        vertices.add(Vector3(x, y, z));
      }
    }

    // 인덱스 생성
    for (int lat = 0; lat < latitudeBands; lat++) {
      for (int long = 0; long < longitudeBands; long++) {
        final first = lat * (longitudeBands + 1) + long + baseIndex;
        final second = first + longitudeBands + 1;

        // 첫 번째 삼각형
        indices.addAll([first, second, first + 1]);
        colors.add(color);

        // 두 번째 삼각형
        indices.addAll([second, second + 1, first + 1]);
        colors.add(color);
      }
    }
  }

  void _createCuboid(DrawingPath path) {
    final corners = ShapeRecognizer.findCorners(path.points);
    // 육면체 메시 생성 로직...
  }

  void _createCone(DrawingPath path) {
    final corners = ShapeRecognizer.findCorners(path.points);
    // 원뿔 메시 생성 로직...
  }

  void _createExtrudedCurve(DrawingPath path) {
    // 곡선을 일단 원으로 처리
    _createSphere(path);
  }

  void _createExtrudedLine(DrawingPath path) {
    // 직선도 일단 구현
    const height = 5.0;
    final color = Vector3(
      path.points.first.paint.color.red / 255,
      path.points.first.paint.color.green / 255,
      path.points.first.paint.color.blue / 255,
    );

    for (int i = 0; i < path.points.length - 1; i++) {
      final p1 = path.points[i].offset;
      final p2 = path.points[i + 1].offset;
      
      final baseIndex = vertices.length;
      
      // 선분의 양 끝점에 높이를 주어 면 생성
      vertices.add(Vector3(p1.dx, p1.dy, 0));
      vertices.add(Vector3(p1.dx, p1.dy, height));
      vertices.add(Vector3(p2.dx, p2.dy, height));
      vertices.add(Vector3(p2.dx, p2.dy, 0));

      // 두 개의 삼각형으로 면 구성
      indices.addAll([
        baseIndex, baseIndex + 1, baseIndex + 2,
        baseIndex, baseIndex + 2, baseIndex + 3,
      ]);
      
      colors.add(color);
      colors.add(color);
    }
  }

  void _calculateNormals() {
    // 각 면의 법선 벡터 계산
    for (int i = 0; i < indices.length; i += 3) {
      final v1 = vertices[indices[i]];
      final v2 = vertices[indices[i + 1]];
      final v3 = vertices[indices[i + 2]];

      final normal = (v2 - v1).cross(v3 - v1).normalized();
      normals.add(normal);
    }
  }

  void rotate(Vector3 rotation) {
    this.rotation += rotation;
  }

  void setScale(double scale) {
    this.scale = scale;
  }

  void setLightPosition(Vector3 position) {
    lightPosition = position;
  }

  void setLightColor(Vector3 color) {
    lightColor = color;
  }

  void setBaseColor(Vector3 color) {
    baseColor = color;
  }
} 