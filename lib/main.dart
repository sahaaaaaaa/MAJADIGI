import 'package:flutter/material.dart';
import 'screens/onboarding/splash_screen.dart';
import 'screens/onboarding/login_screen.dart';

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
        fontFamily: 'Onest',
        scaffoldBackgroundColor: Colors.white,
      ),

      // 🔥 START DARI SPLASH
      initialRoute: '/',

      // 🔥 ROUTES
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}