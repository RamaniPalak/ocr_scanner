import 'package:flutter/material.dart';
import 'presentation/pages/home_screen.dart';

void main() {
  runApp(const OCRScannerApp());
}

class OCRScannerApp extends StatelessWidget {
  const OCRScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCR Scanner App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
         ),
      ),
      home: const HomeScreen(),
    );
  }
}
