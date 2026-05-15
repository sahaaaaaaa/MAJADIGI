import 'package:flutter/material.dart';

import 'screens/onboarding/login_screen.dart';
import 'widgets/main_navigation.dart';

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

      // 🔥 BYPASS LANGSUNG HOME
      home: const MainNavigation(),

      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}