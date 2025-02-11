import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'drawing_model.dart';

enum ShapeType {
  circle,
  rectangle,
  triangle,
  curve,
  line
}

class ShapeRecognizer {
  static ShapeType recognizeShape(List<DrawingPoint> points) {
    print('도형 인식 시작: ${points.length} 포인트');
    
    if (points.length < 3) {
      print('포인트가 3개 미만: 직선으로 판단');
      return ShapeType.line;
    }

    // 시작점과 끝점의 거리
    final start = points.first.offset;
    final end = points.last.offset;
    final distance = (end - start).distance;
    print('시작점과 끝점 거리: $distance');

    // 도형의 둘레 계산
    double perimeter = 0;
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i].offset;
      final p2 = points[i + 1].offset;
      perimeter += (p2 - p1).distance;
    }
    print('둘레 길이: $perimeter');

    // 원 판별 - 기준 완화
    if (distance < perimeter * 0.3) {  // 0.2에서 0.3으로 증가
      print('원 후보: 시작점과 끝점이 가까움');
      final center = calculateCenter(points);
      final radius = calculateAverageRadius(points, center);
      final radiusVariance = calculateRadiusVariance(points, center, radius);
      
      print('반지름 분산: $radiusVariance, 기준: ${radius * 0.3}');  // 0.2에서 0.3으로 증가
      if (radiusVariance < radius * 0.3) {  // 허용 오차 증가
        print('원으로 판단됨');
        return ShapeType.circle;
      }
    }

    // 사각형 판별: 네 개의 코너가 있는 경우
    final corners = findCorners(points);
    if (corners.length == 4) {
      return ShapeType.rectangle;
    }

    // 삼각형 판별: 세 개의 코너가 있는 경우
    if (corners.length == 3) {
      return ShapeType.triangle;
    }

    // 나머지는 곡선으로 처리
    return ShapeType.curve;
  }

  static Offset calculateCenter(List<DrawingPoint> points) {
    double sumX = 0;
    double sumY = 0;
    for (final point in points) {
      sumX += point.offset.dx;
      sumY += point.offset.dy;
    }
    return Offset(sumX / points.length, sumY / points.length);
  }

  static double calculateAverageRadius(List<DrawingPoint> points, Offset center) {
    double sumRadius = 0;
    for (final point in points) {
      sumRadius += (point.offset - center).distance;
    }
    return sumRadius / points.length;
  }

  static double calculateRadiusVariance(
    List<DrawingPoint> points,
    Offset center,
    double avgRadius,
  ) {
    double sumVariance = 0;
    for (final point in points) {
      final radius = (point.offset - center).distance;
      sumVariance += math.pow(radius - avgRadius, 2);
    }
    return math.sqrt(sumVariance / points.length);
  }

  static List<Offset> findCorners(List<DrawingPoint> points) {
    List<Offset> corners = [];
    const angleThreshold = math.pi / 6;

    for (int i = 1; i < points.length - 1; i++) {
      final prev = points[i - 1].offset;
      final curr = points[i].offset;
      final next = points[i + 1].offset;

      final angle = calculateAngle(prev, curr, next);
      if (angle < angleThreshold) {
        corners.add(curr);
      }
    }

    return corners;
  }

  static double calculateAngle(Offset p1, Offset p2, Offset p3) {
    final v1 = p1 - p2;
    final v2 = p3 - p2;
    return math.acos(
      (v1.dx * v2.dx + v1.dy * v2.dy) /
      (math.sqrt(v1.dx * v1.dx + v1.dy * v1.dy) *
       math.sqrt(v2.dx * v2.dx + v2.dy * v2.dy))
    );
  }
} 