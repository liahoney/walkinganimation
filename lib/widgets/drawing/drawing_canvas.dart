import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/drawing_viewmodel.dart';
import '../../models/drawing_model.dart';

class DrawingCanvas extends StatelessWidget {
  const DrawingCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DrawingViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
          ),
          child: GestureDetector(
            onPanStart: (details) {
              final box = context.findRenderObject() as RenderBox;
              final offset = box.globalToLocal(details.globalPosition);
              viewModel.startDrawing(offset);
            },
            onPanUpdate: (details) {
              final box = context.findRenderObject() as RenderBox;
              final offset = box.globalToLocal(details.globalPosition);
              viewModel.addPoint(offset);
            },
            onPanEnd: (details) {
              viewModel.endDrawing();
            },
            onPanCancel: () {
              viewModel.endDrawing();
            },
            child: CustomPaint(
              painter: DrawingPainter(
                paths: viewModel.paths,
                currentPoints: viewModel.currentPoints,
              ),
              size: Size.infinite,
            ),
          ),
        );
      },
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPath> paths;
  final List<DrawingPoint> currentPoints;

  DrawingPainter({
    required this.paths,
    required this.currentPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 완성된 경로들 그리기
    for (final path in paths) {
      for (int i = 0; i < path.points.length - 1; i++) {
        canvas.drawLine(
          path.points[i].offset,
          path.points[i + 1].offset,
          path.points[i].paint,
        );
      }
    }

    // 현재 그리고 있는 경로 그리기
    for (int i = 0; i < currentPoints.length - 1; i++) {
      canvas.drawLine(
        currentPoints[i].offset,
        currentPoints[i + 1].offset,
        currentPoints[i].paint,
      );
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
} 