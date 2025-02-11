import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/drawing_viewmodel.dart';
import '../viewmodels/three_viewmodel.dart';
import '../widgets/drawing/drawing_canvas.dart';
import '../widgets/drawing/drawing_tools.dart';
import '../widgets/drawing/color_palette.dart';
import '../widgets/three/three_scene.dart';
import '../views/three_view.dart';

class DrawingView extends StatelessWidget {
  const DrawingView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DrawingViewModel(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: const Text('그림 그리기'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                Provider.of<DrawingViewModel>(context, listen: false).clear();
              },
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                print('전송 버튼 클릭됨');
                final drawingViewModel = Provider.of<DrawingViewModel>(context, listen: false);
                final threeViewModel = ThreeViewModel();
                
                print('paths 길이: ${drawingViewModel.paths.length}');
                threeViewModel.convertFromDrawing(drawingViewModel.paths);
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThreeView(
                      viewModel: threeViewModel,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(8.0),
          child: _buildDrawingSection(),
        ),
      ),
    );
  }

  Widget _buildDrawingSection() {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(8.0),
            child: const DrawingCanvas(),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: const [
              ColorPalette(),
              SizedBox(height: 8),
              DrawingTools(),
            ],
          ),
        ),
      ],
    );
  }
} 