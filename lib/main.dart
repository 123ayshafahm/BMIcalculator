import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C1B1F),
        primaryColor: const Color(0xFFD4FF70),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4FF70),
          surface: Color(0xFF2D2C30),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
