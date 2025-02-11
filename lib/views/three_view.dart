import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/three/three_scene.dart';
import '../viewmodels/three_viewmodel.dart';

class ThreeView extends StatelessWidget {
  final ThreeViewModel viewModel;  // ViewModel을 생성자로 받음
  
  const ThreeView({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    print('ThreeView 빌드: ${viewModel.vertices.length} 정점');  // 디버그 로그 추가
    return ChangeNotifierProvider.value(  // 기존 ViewModel 인스턴스 사용
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('3D 변환 결과'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const ThreeScene(),
      ),
    );
  }
} 