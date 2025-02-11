import 'package:flutter/material.dart';
import 'views/coloring_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '컬러링 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ColoringPage(),
    );
  }
}
