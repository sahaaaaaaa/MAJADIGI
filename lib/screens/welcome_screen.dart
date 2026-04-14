import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    top: -140,
                    left: -120,
                    child: Container(
                      width: 520,
                      height: 320,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 90),
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(34),
                          topRight: Radius.circular(34),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildTopHeader(),
                            const SizedBox(height: 22),
                            _buildHeroImage(),
                            const SizedBox(height: 14),
                            _buildSliderIndicator(),
                            const SizedBox(height: 24),
                            const Text(
                              'Selamat datang di Majadigi',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D1B4C),
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Platform layanan publik Jawa Timur. Simple. Cerdas.\nTerhubung sepenuhnya',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.45,
                                color: Color(0xFF666666),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 28),
                            _buildPrimaryButton(
                              text: 'Masuk',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 14),
                            _buildSecondaryBlueButton(
                              text: 'Belum punya akun? Daftar dulu',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 26),
                            _buildDividerText(),
                            const SizedBox(height: 26),
                            _buildGuestButton(
                              text: 'Masuk tanpa daftar',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Masuk tanpa daftar ditekan'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: 42,
                height: 42,
                child: Image.asset(
                  'assets/images/logo_majadigi.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.bubble_chart_rounded,
                      color: Color(0xFF0E63FF),
                      size: 36,
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MAJADIGI',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1453D1),
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    'Majapahit Digital',
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF888888),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFFE2E2E2), width: 1),
          ),
          child: const Row(
            children: [
              Icon(Icons.language, size: 18, color: Color(0xFF4F4F4F)),
              SizedBox(width: 6),
              Text(
                'Bahasa Indonesia',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF4F4F4F),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        width: double.infinity,
        height: 225,
        child: Image.asset(
          'assets/images/welcome_hero.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFDDE9FF),
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 56,
                  color: Color(0xFF0E63FF),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliderIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 38,
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFF0E63FF),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(width: 6),
        ...List.generate(
          4,
          (index) => Container(
            margin: const EdgeInsets.only(right: 6),
            width: 10,
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF0E63FF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildSecondaryBlueButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFDCE7F8),
          foregroundColor: const Color(0xFF0E63FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildDividerText() {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 1, color: Color(0xFFE0E0E0))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'atau',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ),
        const Expanded(child: Divider(thickness: 1, color: Color(0xFFE0E0E0))),
      ],
    );
  }

  Widget _buildGuestButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF5A5A5A),
          side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
