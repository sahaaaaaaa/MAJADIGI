import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MajadigiApp());
}

class MajadigiApp extends StatelessWidget {
  const MajadigiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Majadigi',
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}