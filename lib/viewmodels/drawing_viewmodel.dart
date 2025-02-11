import 'package:flutter/material.dart';
import '../models/drawing_model.dart';

class DrawingViewModel extends ChangeNotifier {
  final DrawingModel _model = DrawingModel();
  bool _isDrawing = false;  // 드래그 상태 추적

  List<DrawingPath> get paths => _model.paths;
  List<DrawingPoint> get currentPoints => _model.currentPoints;
  Color get currentColor => _model.currentColor;
  double get strokeWidth => _model.strokeWidth;
  bool get isEraser => _model.isEraser;
  bool get isDrawing => _isDrawing;

  void startDrawing(Offset offset) {
    _isDrawing = true;
    _model.addPoint(offset);
    notifyListeners();
  }

  void addPoint(Offset offset) {
    if (!_isDrawing) return;  // 드래그 중일 때만 점 추가
    _model.addPoint(offset);
    notifyListeners();
  }

  void endDrawing() {
    _isDrawing = false;
    _model.endPath();  // 현재 경로 완료
    notifyListeners();
  }

  void clear() {
    _model.clear();
    notifyListeners();
  }

  void setColor(Color color) {
    _model.setColor(color);
    notifyListeners();
  }

  void setStrokeWidth(double width) {
    _model.setStrokeWidth(width);
    notifyListeners();
  }

  void toggleEraser() {
    _model.toggleEraser();
    notifyListeners();
  }
} 