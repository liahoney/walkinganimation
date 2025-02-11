import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/drawing_viewmodel.dart';

class DrawingTools extends StatelessWidget {
  const DrawingTools({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStrokeWidthSlider(context),
          _buildEraserButton(context),
          _buildClearButton(context),
        ],
      ),
    );
  }

  Widget _buildStrokeWidthSlider(BuildContext context) {
    return Expanded(
      child: Slider(
        value: Provider.of<DrawingViewModel>(context).strokeWidth,
        min: 1,
        max: 20,
        onChanged: (value) {
          Provider.of<DrawingViewModel>(context, listen: false)
              .setStrokeWidth(value);
        },
      ),
    );
  }

  Widget _buildEraserButton(BuildContext context) {
    final isEraser = Provider.of<DrawingViewModel>(context).isEraser;
    return IconButton(
      icon: Icon(
        Icons.edit_off,
        color: isEraser ? Colors.blue : Colors.grey,
      ),
      onPressed: () {
        Provider.of<DrawingViewModel>(context, listen: false).toggleEraser();
      },
    );
  }

  Widget _buildClearButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.clear),
      onPressed: () {
        Provider.of<DrawingViewModel>(context, listen: false).clear();
      },
    );
  }
} 