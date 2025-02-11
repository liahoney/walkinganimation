import 'dart:ui' as ui;
import 'dart:math';  // dart:math 패키지 추가
import 'package:flutter/material.dart' hide Color, Paint, Path;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xml/xml.dart';
import 'package:path_drawing/path_drawing.dart' as path_drawing;  // 명시적으로 이름 지정
import 'package:flutter/rendering.dart';

class ColoringPage extends StatefulWidget {
  const ColoringPage({super.key});

  @override
  State<ColoringPage> createState() => _ColoringPageState();
}

class _ColoringPageState extends State<ColoringPage> {
  ui.Color selectedColor = const ui.Color(0xFFFF0000);
  final List<DrawingPoint?> drawingPoints = [];
  bool isDrawingMode = true;
  double strokeWidth = 3.0;
  final List<ui.Path> svgPaths = [];
  final List<ui.Paint> pathPaints = [];
  bool isSvgLoaded = false;  // SVG 로딩 상태 추적
  double _scale = 1.0;
  Matrix4? _transformMatrix;

  @override
  void initState() {
    super.initState();
    // 위젯이 생성된 후 SVG 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSvg();
    });
  }

  Future<void> _loadSvg() async {
    try {
      print('SVG 로딩 시작');
      final String svgString = await DefaultAssetBundle.of(context)
          .loadString('assets/images/bluey.svg');
      print('SVG 문자열 로드됨');
      
      final document = XmlDocument.parse(svgString);
      final paths = document.findAllElements('path');
      
      setState(() {
        svgPaths.clear();
        pathPaints.clear();
        
        for (final path in paths) {
          final pathData = path.getAttribute('d') ?? '';
          final fillColor = path.getAttribute('fill') ?? '#000000';
          
          final svgPath = parseSvgPath(pathData);
          svgPaths.add(svgPath);
          
          final paint = ui.Paint()
            ..style = ui.PaintingStyle.fill
            ..color = _parseColor(fillColor);
          pathPaints.add(paint);
          
          print('경로 추가됨: ${svgPath.getBounds()}');
        }
        
        isSvgLoaded = true;
        print('SVG 로딩 완료: ${svgPaths.length} 경로');
      });
    } catch (e, stackTrace) {
      print('SVG 로딩 에러: $e');
      print('스택 트레이스: $stackTrace');
    }
  }

  ui.Path parseSvgPath(String pathData) {
    // path_drawing 패키지의 parseSvgPathData 사용
    return path_drawing.parseSvgPathData(pathData);
  }

  // 색상 파싱 헬퍼 메서드 추가
  ui.Color _parseColor(String colorString) {
    if (colorString.startsWith('#')) {
      String hex = colorString.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF' + hex; // 알파 채널 추가
      }
      return ui.Color(int.parse(hex, radix: 16));
    }
    return const ui.Color(0xFF000000); // 기본값 검정색
  }

  void _onPanStart(DragStartDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    
    // 터치 좌표를 SVG 좌표계로 변환
    final transformedPoint = _transformToSvgCoordinates(point);
    
    final paint = ui.Paint()
      ..color = selectedColor
      ..strokeCap = ui.StrokeCap.round
      ..strokeWidth = strokeWidth
      ..style = ui.PaintingStyle.fill;
    
    setState(() {
      drawingPoints.add(DrawingPoint(transformedPoint, paint));
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    
    // 터치 좌표를 SVG 좌표계로 변환
    final transformedPoint = _transformToSvgCoordinates(point);
    
    setState(() {
      drawingPoints.add(DrawingPoint(transformedPoint, drawingPoints.last!.paint));
    });
  }

  // 좌표 변환 헬퍼 메서드 추가
  Offset _transformToSvgCoordinates(Offset point) {
    if (svgPaths.isEmpty) return point;
    
    // SVG 전체 크기 계산
    ui.Rect? totalBounds;
    for (final path in svgPaths) {
      final bounds = path.getBounds();
      totalBounds = totalBounds?.expandToInclude(bounds) ?? bounds;
    }
    
    if (totalBounds == null) return point;
    
    final svgWidth = totalBounds.width;
    final svgHeight = totalBounds.height;
    
    final scaleX = MediaQuery.of(context).size.width / svgWidth;
    final scaleY = MediaQuery.of(context).size.height / svgHeight;
    final baseScale = min(scaleX, scaleY) * 0.8;
    
    final dx = (MediaQuery.of(context).size.width - (svgWidth * baseScale)) / 2;
    final dy = (MediaQuery.of(context).size.height - (svgHeight * baseScale)) / 2;
    
    // 화면 좌표를 SVG 좌표로 변환
    return Offset(
      (point.dx - dx) / baseScale,
      svgHeight - (point.dy - dy) / baseScale, // y 좌표 반전
    );
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      drawingPoints.add(null);
    });
  }

  void _onTapDown(TapDownDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    
    // 터치한 위치의 SVG 경로 찾기
    for (int i = 0; i < svgPaths.length; i++) {
      final path = svgPaths[i];
      if (_isPointInPath(point, path)) {
        setState(() {
          // 선택된 경로의 색상 변경
          pathPaints[i] = ui.Paint()
            ..style = ui.PaintingStyle.fill
            ..color = selectedColor;
        });
        break;
      }
    }
  }
  
  bool _isPointInPath(Offset point, ui.Path path) {
    // 터치 좌표를 SVG 좌표계로 변환
    final bounds = path.getBounds();
    final svgWidth = bounds.width;
    final svgHeight = bounds.height;
    
    final scaleX = MediaQuery.of(context).size.width / svgWidth;
    final scaleY = MediaQuery.of(context).size.height / svgHeight;
    final baseScale = min(scaleX, scaleY) * 0.8;
    
    final dx = (MediaQuery.of(context).size.width - (svgWidth * baseScale)) / 2;
    final dy = (MediaQuery.of(context).size.height - (svgHeight * baseScale)) / 2;
    
    // 터치 좌표를 SVG 좌표계로 변환
    final transformedPoint = Offset(
      (point.dx - dx) / baseScale,
      (point.dy - dy) / baseScale,
    );
    
    return path.contains(transformedPoint);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // SVG와 그리기 캔버스
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            onTapDown: _onTapDown,
            child: CustomPaint(
              painter: ColoringPainter(
                drawingPoints: drawingPoints,
                svgPaths: svgPaths,
                pathPaints: pathPaints,
                scale: _scale,
                strokeWidth: strokeWidth,
              ),
              size: Size(
                MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height,
              ),
            ),
          ),
          
          // 색상 선택 버튼들
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ColorPaletteButton(
                  color: const ui.Color(0xFF000000),
                  onTap: () => setState(() => selectedColor = const ui.Color(0xFF000000)),
                ),
                ColorPaletteButton(
                  color: const ui.Color(0xFFFF0000),
                  onTap: () => setState(() => selectedColor = const ui.Color(0xFFFF0000)),
                ),
                ColorPaletteButton(
                  color: const ui.Color(0xFF0000FF),
                  onTap: () => setState(() => selectedColor = const ui.Color(0xFF0000FF)),
                ),
                ColorPaletteButton(
                  color: const ui.Color(0xFF00FF00),
                  onTap: () => setState(() => selectedColor = const ui.Color(0xFF00FF00)),
                ),
                ColorPaletteButton(
                  color: const ui.Color(0xFFFFFF00),
                  onTap: () => setState(() => selectedColor = const ui.Color(0xFFFFFF00)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawingPoint {
  final ui.Offset offset;
  final ui.Paint paint;

  DrawingPoint(this.offset, this.paint);
}

class ColoringPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;
  final List<ui.Path> svgPaths;
  final List<ui.Paint> pathPaints;
  final double scale;
  final double strokeWidth;

  ColoringPainter({
    required this.drawingPoints,
    required this.svgPaths,
    required this.pathPaints,
    required this.scale,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    
    try {
      ui.Rect? totalBounds;
      for (final path in svgPaths) {
        final bounds = path.getBounds();
        totalBounds = totalBounds?.expandToInclude(bounds) ?? bounds;
      }
      
      if (totalBounds != null) {
        final svgWidth = totalBounds.width;
        final svgHeight = totalBounds.height;
        
        final scaleX = size.width / svgWidth;
        final scaleY = size.height / svgHeight;
        final baseScale = min(scaleX, scaleY) * 0.8;
        
        final dx = (size.width - (svgWidth * baseScale)) / 2;
        final dy = (size.height - (svgHeight * baseScale)) / 2;
        
        canvas.translate(dx, dy + svgHeight * baseScale);
        canvas.scale(baseScale, -baseScale);
        
        // SVG 경로 그리기
        for (int i = 0; i < svgPaths.length; i++) {
          canvas.drawPath(svgPaths[i], pathPaints[i]);
        }
        
        // 그리기 포인트 그리기
        for (int i = 0; i < drawingPoints.length - 1; i++) {
          if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
            canvas.drawLine(
              drawingPoints[i]!.offset,
              drawingPoints[i + 1]!.offset,
              drawingPoints[i]!.paint..strokeWidth = strokeWidth / baseScale, // 스케일에 맞게 선 두께 조정
            );
          }
        }
      }
    } catch (e) {
      print('그리기 에러: $e');
    }
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ColorPaletteButton extends StatelessWidget {
  final ui.Color color;
  final VoidCallback onTap;

  const ColorPaletteButton({
    super.key,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: const ui.Color(0xFF000000),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
} 