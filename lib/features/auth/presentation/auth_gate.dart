import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:majadigi/features/auth/presentation/auth_controller.dart';
import 'package:majadigi/screens/onboarding/welcome_screen.dart';
import 'package:majadigi/widgets/main_navigation.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return authState.when(
      loading: () => const _AuthLoadingView(),
      error: (_, __) => const WelcomeScreen(),
      data: (session) {
        if (session != null) {
          return const MainNavigation();
        }
        return const WelcomeScreen();
      },
    );
  }
}

class _AuthLoadingView extends StatelessWidget {
  const _AuthLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0D57E7),
      body: Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }
}
