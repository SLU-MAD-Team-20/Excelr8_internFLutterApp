import 'package:flutter/material.dart';
import 'screens/landing_screen.dart';

void main() {
  runApp(const ExcelerateApp());
}

class ExcelerateApp extends StatelessWidget {
  const ExcelerateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Excelerate',
      home: const LandingScreen(),
    );
  }
}