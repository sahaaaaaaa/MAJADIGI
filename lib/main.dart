import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi/features/auth/presentation/auth_gate.dart';
import 'package:majadigi/screens/onboarding/login_screen.dart';

void main() {
  runApp(const ProviderScope(child: MajadigiApp()));
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

      home: const AuthGate(),

      routes: {'/login': (context) => const LoginScreen()},
    );
  }
}
