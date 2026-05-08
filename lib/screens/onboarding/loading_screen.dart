import 'package:flutter/material.dart';
import 'package:majadigi/widgets/main_navigation.dart';
import 'dart:async';

class LoadingLayanan extends StatefulWidget {
  const LoadingLayanan({super.key});

  @override
  State<LoadingLayanan> createState() => _LoadingLayananState();
}

class _LoadingLayananState extends State<LoadingLayanan> {
  @override
  void initState() {
    super.initState();
    // Jalankan timer 3 detik
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigation()),
          (route) => false,
        );
      }
    });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7), 
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 60), 
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: CircularProgressIndicator(
                            strokeWidth: 6,
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0E63FF)),
                            backgroundColor: Colors.grey[200],
                          ),
                        ),
                        const SizedBox(height: 40),

                        const Text(
                          'Layanan sedang di buat...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D1B4C),
                            fontFamily: 'Onest',
                          ),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          'Tunggu sebentar, layananmu sedang didownload dan akan siap kamu gunakan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

