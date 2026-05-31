import 'package:flutter/material.dart';

import '../screens/beranda/home_screen.dart';
import '../screens/layanan/layanan_screen.dart';
import '../screens/tersimpan/tersimpan_screen.dart';
import '../screens/akun/akun_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  int _homeRefreshVersion = 0;
  int _savedRefreshVersion = 0;

  List<Widget> get _pages => [
    HomeScreen(refreshVersion: _homeRefreshVersion),
    const LayananScreen(),
    TersimpanScreen(refreshVersion: _savedRefreshVersion),
    const AkunScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: SafeArea(
        child: Container(
          height: 90,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),

          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(40),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),

                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Row(
            children: [
              Expanded(child: _navItem(Icons.home_filled, "Beranda", 0)),

              Expanded(
                child: _navItem(Icons.storefront_outlined, "Layanan", 1),
              ),

              Expanded(child: _navItem(Icons.bookmark_border, "Tersimpan", 2)),

              Expanded(child: _navItem(Icons.person_outline, "Akun", 3)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (index == 0) {
            _homeRefreshVersion++;
          }
          if (index == 2) {
            _savedRefreshVersion++;
          }
          _currentIndex = index;
        });
      },

      child: SizedBox(
        height: 70,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),

          width: double.infinity,

          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),

          decoration: BoxDecoration(
            color: isActive ? const Color(0xffE9F0FF) : Colors.transparent,

            borderRadius: BorderRadius.circular(24),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Icon(
                icon,

                color: isActive ? const Color(0xff2F61E8) : Colors.grey,

                size: 24,
              ),

              const SizedBox(height: 4),

              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  color: isActive ? const Color(0xff2F61E8) : Colors.grey,

                  fontSize: 12,

                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
