import 'package:flutter/material.dart';
import '../constants/animations.dart';
import 'drawing_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '3D 드로잉 변환기',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40),
                      const Icon(
                        Icons.draw,
                        size: 100,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            Animations.fadeRoute(const DrawingView()),
                          );
                        },
                        icon: const Icon(Icons.draw),
                        label: const Text(
                          '그림 그리기 시작하기',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 