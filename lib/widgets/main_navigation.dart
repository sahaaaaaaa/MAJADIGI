import 'package:flutter/material.dart';

import '../screens/beranda/home_screen.dart';
import '../screens/layanan/layanan_screen.dart';
import '../screens/tersimpan/tersimpan_screen.dart';
import '../screens/akun/akun_screen.dart';

import '../screens/onboarding/recommendation_screen.dart';
import '../screens/service_model.dart';


class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    LayananScreen(),
    TersimpanScreen(
      selectedIds: {1,2,3,4,5,6,7,8}, // Set kosong untuk sementara
      allData: recommendations, // List kosong untuk sementara
    ),
    const AkunScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_currentIndex],
      

      bottomNavigationBar: 
      SafeArea(child: Container(
        margin: const EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(40),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                0.08,
              ),

              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,

          children: [

            _navItem(
              Icons.home_filled,
              "Beranda",
              0,
            ),

            _navItem(
              Icons.storefront_outlined,
              "Layanan",
              1,
            ),

            _navItem(
              Icons.bookmark_border,
              "Tersimpan",
              2,
            ),

            _navItem(
              Icons.person_outline,
              "Akun",
              3,
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    int index,
  ) {

    final isActive =
        _currentIndex == index;

    return GestureDetector(
      onTap: () {

        setState(() {
          _currentIndex = index;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 250,
        ),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),

        decoration: BoxDecoration(
          color: isActive
              ? const Color(
                  0xffE9F0FF,
                )
              : Colors.transparent,

          borderRadius:
              BorderRadius.circular(24),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            Icon(
              icon,

              color: isActive
                  ? const Color(
                      0xff2F61E8,
                    )
                  : Colors.grey,

              size: 24,
            ),

            const SizedBox(height: 4),

            Text(
              label,

              style: TextStyle(
                color: isActive
                    ? const Color(
                        0xff2F61E8,
                      )
                    : Colors.grey,

                fontSize: 13,

                fontWeight: isActive
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}