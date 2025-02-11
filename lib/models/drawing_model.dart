import 'package:flutter/material.dart';

class DrawingPoint {
  final Offset offset;
  final Paint paint;

  DrawingPoint({required this.offset, required this.paint});
}

class DrawingPath {
  final List<DrawingPoint> points;
  
  DrawingPath({required List<DrawingPoint> points}) : points = List.from(points);
}

class DrawingModel {
  final List<DrawingPath> paths = [];  // 여러 개의 경로를 저장
  List<DrawingPoint> currentPoints = [];  // 현재 그리고 있는 경로의 점들
  Color currentColor = const Color(0xFF000000);
  double strokeWidth = 3.0;
  bool isEraser = false;

  Paint get currentPaint => Paint()
    ..color = isEraser ? const Color(0xFFFFFFFF) : currentColor
    ..strokeWidth = strokeWidth
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..style = PaintingStyle.stroke;

  void addPoint(Offset offset) {
    currentPoints.add(DrawingPoint(offset: offset, paint: currentPaint));
  }

  void endPath() {
    if (currentPoints.isNotEmpty) {
      paths.add(DrawingPath(points: currentPoints));
      currentPoints = [];  // 현재 점들 초기화
    }
  }

  void clear() {
    paths.clear();
    currentPoints.clear();
  }

  void setColor(Color color) {
    currentColor = color;
    isEraser = false;
  }

  void setStrokeWidth(double width) {
    strokeWidth = width;
  }

  void toggleEraser() {
    isEraser = !isEraser;
  }
} 