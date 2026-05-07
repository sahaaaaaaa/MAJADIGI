import 'package:flutter/material.dart';
import 'register_screen.dart';
import '../widgets/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7),
      body: SafeArea(
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 14, 24, 12),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Kembali',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(34),
                        topRight: Radius.circular(34),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildTopHeader(),
                          const SizedBox(height: 34),
                          const Text(
                            'Masuk',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D1B4C),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Akses layanan publik di Jawa Timur lebih mudah\ndalam satu aplikasi',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: Color(0xFF666666),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildEmailField(),
                          const SizedBox(height: 18),
                          _buildPasswordField(),
                          const SizedBox(height: 18),
                          _buildRememberForgotRow(),
                          const SizedBox(height: 28),
                          _buildLoginButton(),
                          const SizedBox(height: 34),
                          _buildRegisterText(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
            border: Border.all(
              color: const Color(0xFFE2E2E2),
              width: 1,
            ),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.language,
                size: 18,
                color: Color(0xFF4F4F4F),
              ),
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

  Widget _buildEmailField() {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Email',
        hintStyle: const TextStyle(
          color: Color(0xFF9B9B9B),
          fontSize: 16,
        ),
        prefixIcon: const Icon(
          Icons.mail_outline,
          color: Color(0xFF2E2E2E),
        ),
        filled: true,
        fillColor: const Color(0xFFF2F6FB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFF0E63FF),
            width: 1.4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFF0E63FF),
            width: 1.6,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        hintText: 'Kata sandi',
        hintStyle: const TextStyle(
          color: Color(0xFF9B9B9B),
          fontSize: 16,
        ),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Color(0xFF8C8C8C),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
          icon: Icon(
            obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: const Color(0xFF8C8C8C),
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFF0E63FF),
            width: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildRememberForgotRow() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              rememberMe = !rememberMe;
            });
          },
          borderRadius: BorderRadius.circular(6),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: rememberMe ? const Color(0xFF0E63FF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: rememberMe
                        ? const Color(0xFF0E63FF)
                        : const Color(0xFFD9D9D9),
                    width: 1.4,
                  ),
                ),
                child: rememberMe
                    ? const Icon(
                        Icons.check,
                        size: 18,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              const Text(
                'Ingat saya',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF9B9B9B),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fitur lupa sandi belum dibuat'),
              ),
            );
          },
          child: const Text(
            'Lupa sandi?',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF9B9B9B),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
  return SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const MainNavigation()),
  );
},
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: const Color(0xFF0E63FF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text(
        "Masuk",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

  Widget _buildRegisterText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Belum punya akun? ',
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF555555),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RegisterScreen()),
            );
          },
          child: const Text(
            'Daftar dulu',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF0E63FF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}