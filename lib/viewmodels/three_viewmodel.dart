import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart';
import '../models/three_model.dart';
import '../models/drawing_model.dart';

class ThreeViewModel extends ChangeNotifier {
  final ThreeModel _model = ThreeModel();
  
  List<Vector3> get vertices => _model.vertices;
  List<Vector3> get normals => _model.normals;
  List<int> get indices => _model.indices;
  Vector3 get rotation => _model.rotation;
  double get scale => _model.scale;

  Vector3 get lightPosition => _model.lightPosition;
  Vector3 get lightColor => _model.lightColor;
  Vector3 get baseColor => _model.baseColor;
  List<Vector3> get colors => _model.colors;

  void convertFromDrawing(List<DrawingPath> paths) {
    _model.convertFromDrawing(paths);
    notifyListeners();
  }

  void rotate(Vector3 rotation) {
    _model.rotate(rotation);
    notifyListeners();
  }

  void setScale(double scale) {
    _model.setScale(scale);
    notifyListeners();
  }

  void setLightPosition(Vector3 position) {
    _model.setLightPosition(position);
    notifyListeners();
  }

  void setLightColor(Vector3 color) {
    _model.setLightColor(color);
    notifyListeners();
  }

  void setBaseColor(Vector3 color) {
    _model.setBaseColor(color);
    notifyListeners();
  }
} 