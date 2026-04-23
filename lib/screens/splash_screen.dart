import 'dart:async';
import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Variabel untuk mengontrol efek fade-in logo
  bool _showLogo = false;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _showLogo = true;
      });
    }); //startAnimation

    Timer(const Duration(milliseconds: 4000), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
        );
      }
    }); //navigateToNextScreen
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/latar_belakang.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // LOGO MAJADIGI (Dengan Animasi Fade)
                  AnimatedOpacity(
                    opacity: _showLogo ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 800),
                    child: Image.asset(
                      'assets/images/logo_majadigi.png',
                      width: 120, // Ukuran disesuaikan
                    ),
                  ),
                  const Spacer(),
                  // FOOTER: Powered By (Teks statis di bawah)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: AnimatedOpacity(
                      opacity: _showLogo ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 1000),
                      child: const Column(
                        children: [
                          Text(
                            "Powered by",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Pemerintah Provinsi Jawa Timur",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}