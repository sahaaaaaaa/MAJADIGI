import 'package:flutter/material.dart';

class LoadingLayanan extends StatelessWidget {
  const LoadingLayanan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Progress Indicator Kustom
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
              
              // 2. Judul Loading
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
              
              // 3. Subtitle / Deskripsi
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
    );
  }
}