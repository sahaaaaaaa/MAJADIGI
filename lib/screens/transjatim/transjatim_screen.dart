import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'daftar_tiket_screen.dart';
import 'daftar_rute_screen.dart';
import 'informasi_transjatim_screen.dart';

class TransjatimScreen extends StatefulWidget {
  const TransjatimScreen({super.key});

  @override
  State<TransjatimScreen> createState() => _TransjatimScreenState();
}

class _TransjatimScreenState extends State<TransjatimScreen> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  final List<String> images = [
    'assets/images/transjatim1.png',
    'assets/images/transjatim2.png',
    'assets/images/transjatim3.png',
  ];

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        currentPage = (currentPage + 1) % images.length;

        _pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Stack(
        children: [
          // 🔵 HEADER
          Container(
            width: double.infinity,
            height: 320,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/latar_belakang.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),

                      const Expanded(
                        child: Text(
                          "Transjatim",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.bookmark_border,
                              color: Colors.white,
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const InformasiTransjatimScreen(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.info_outline,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // 🔥 SLIDER
                        SizedBox(
                          height: 210,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: images.length,
                            onPageChanged: (index) {
                              setState(() {
                                currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: Image.asset(
                                    images[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 12),

                        // INDICATOR
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            images.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: currentPage == index ? 30 : 10,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: currentPage == index
                                    ? Colors.white
                                    : Colors.white54,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // SEARCH
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),

                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/icons/marker-pin-01.svg',
                                  width: 22,
                                ),

                                const SizedBox(width: 12),

                                const Text(
                                  "Mau kemana hari ini?",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // CONTENT
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(34),
                            ),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Layanan",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF121938),
                                  ),
                                ),

                                const SizedBox(height: 18),

                                _serviceCard(
                                  icon: 'assets/images/icons/ticket-01.svg',
                                  title: "Tiket Trans Jatim",
                                  subtitle: "Tiket Trans Jatim",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const DaftarTiketScreen(),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 16),

                                _serviceCard(
                                  icon: 'assets/images/icons/route.svg',
                                  title: "Rute Trans Jatim",
                                  subtitle: "Rute perjalanan Trans Jatim",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const DaftarRuteScreen(),
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 30),
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
          ),
        ],
      ),
    );
  }

  Widget _serviceCard({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBFD4FF)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, width: 24),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF121938),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onTap,

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565FF),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),

              child: const Text(
                "Selengkapnya",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
