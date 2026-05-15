import 'dart:async';
import 'package:flutter/material.dart';
import 'layanan_lain.dart';
import '../../widgets/layanan_item.dart';
<<<<<<<< HEAD:lib/screens/beranda/home_screen.dart
import '../destinasi_wisata/destinasi_wisata_screen.dart';
import '../klinik_hoax/klinik_hoax_home_screen.dart';
import '../open_data/open_data_screen.dart';
========
import '../destinasi/destinasi_wisata_screen.dart';
import '../harga_barang/harga_bahan_pokok_screen.dart';
>>>>>>>> origin/salma:lib/screens/homescreen/home_screen.dart

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _controller = PageController();
  int _currentPage = 1;

  final List<String> banners = [
    "assets/images/welcome_hero2.jpg",
    "assets/images/welcome_hero.png",
    "assets/images/welcome_hero3.jpg",
  ];

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller.hasClients) {
        _currentPage = (_currentPage + 1) % banners.length;
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,

      body: Container(
        color: const Color(0xFFF2F2F2),

        child: Stack(
          children: [
      
          // HEADER
          Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Color(0xFF0D57E7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // HEADER TOP
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.blue),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selamat Datang",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Arief W.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.search, color: Colors.white),
                      const SizedBox(width: 12),
                      const Icon(Icons.notifications_none, color: Colors.white),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // SLIDER
                SizedBox(
                  height: 180,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: banners.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return _bannerImage(banners[index]);
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // DOT
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    banners.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // CONTENT
                Expanded(
                  child: Container(
                    clipBehavior: Clip.none,
                    padding: const EdgeInsets.all(20),
                  
                    decoration: const BoxDecoration(
<<<<<<<< HEAD:lib/screens/beranda/home_screen.dart
                      color: const Color(0xFFF8F8F8),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30)),
========
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
>>>>>>>> origin/salma:lib/screens/homescreen/home_screen.dart
                    ),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(
                        0,
                        0,
                        0,
                        140,
                      ),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Layanan",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
<<<<<<<< HEAD:lib/screens/beranda/home_screen.dart
                                      builder: (_) =>
                                          LayananLainScreen(
                                            kategori: "Pariwisata & Kebudayaan",
                                          )),
========
                                    builder: (_) => const LayananLainScreen(),
                                  ),
>>>>>>>> origin/salma:lib/screens/homescreen/home_screen.dart
                                );
                              },
                              child: const Text(
                                "Semua layanan",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        GridView.count(
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            LayananItem(
                              title: "Klinik Hoaks",
                              image: "assets/images/klinik_hoax.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const KlinikHoaksHomeScreen()),
                                );
                              },
                            ),

                            LayananItem(
                              title: "Destinasi Wisata",
                              image: "assets/images/destinasi_wisata.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const DestinasiWisataScreen(),
                                  ),
                                );
                              },
                            ),

                            LayananItem(
                              title: "Open Data",
                              image: "assets/images/open_data.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const OpenDataScreen()),
                                );
                              },
                            ),

                            LayananItem(
                              title: "Harga",
                              image: "assets/images/khas_jatim.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const HargaBahanPokokScreen(),
                                  ),
                                );
                              },
                            ),

                            LayananItem(
                              title: "RSUD Haji",
                              image: "assets/images/rsud_haji.png",
                              onTap: () {},
                            ),

                            LayananItem(
                              title: "Transjatim",
                              image: "assets/images/transjatim_ajaib.png",
                              onTap: () {},
                            ),

                            LayananItem(
                              title: "RSSA",
                              image: "assets/images/rsud_saifulanwar.png",
                              onTap: () {},
                            ),

                            LayananItem(
                              title: "Lainnya",
                              image: "assets/images/grid_lainnya.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
<<<<<<<< HEAD:lib/screens/beranda/home_screen.dart
                                      builder: (_) =>
                                          LayananLainScreen(
                                            kategori: "Pariwisata & Kebudayaan",
                                          )),
========
                                    builder: (_) => const LayananLainScreen(),
                                  ),
>>>>>>>> origin/salma:lib/screens/homescreen/home_screen.dart
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          "Jatim Dalam Angka",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: const [
                            Expanded(
                              child: _StatCard(
                                "40.876.641",
                                "Jumlah Penduduk",
                                "assets/images/icon_user.png",
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                "0.73%",
                                "Pertumbuhan Penduduk",
                                "assets/images/icon_penduduk.png",
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _StatCard(
                                "9.65%",
                                "Pertumbuhan Ekonomi",
                                "assets/images/icon_ekonomi.png",
                              ),
                            ),
                          ],
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
      ),
    );
  }

  Widget _bannerImage(String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(path, fit: BoxFit.cover),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String icon;

  const _StatCard(this.value, this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(icon, width: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
