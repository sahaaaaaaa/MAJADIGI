import 'dart:async';
import 'package:flutter/material.dart';
import 'home_service_item.dart';
import 'layanan_lain.dart';
import '../../widgets/layanan_item.dart';
import '../../services/layanan_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _controller = PageController();
  final LayananService _layananService = LayananService();
  int _currentPage = 1;
  Timer? _bannerTimer;
  bool _hasLoadedLayanan = false;
  List<LayananModel> _installedLayanan = [];

  final List<String> banners = [
    "assets/images/welcome_hero2.jpg",
    "assets/images/welcome_hero.png",
    "assets/images/welcome_hero3.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _loadInstalledLayanan();

    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
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
    _bannerTimer?.cancel();
    _controller.dispose();
    _layananService.dispose();
    super.dispose();
  }

  Future<void> _loadInstalledLayanan() async {
    try {
      final layanan = await _layananService.getInstalledLayanan();
      if (!mounted) {
        return;
      }
      setState(() {
        _installedLayanan = layanan;
        _hasLoadedLayanan = true;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _hasLoadedLayanan = true;
      });
    }
  }

  List<HomeServiceItem> get _homeServices {
    return _installedLayanan
        .map(homeServiceFromLayanan)
        .whereType<HomeServiceItem>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Stack(
        children: [
          // HEADER
          // Latar Belakang Biru
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/latar_belakang.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
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
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
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
                                final services =
                                    _hasLoadedLayanan ? _homeServices : null;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        LayananLainScreen(services: services),
                                  ),
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

                        _buildLayananSection(),

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

  Widget _buildLayananSection() {
    if (!_hasLoadedLayanan) {
      return const SizedBox(
        height: 96,
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    final services = _homeServices;
    if (services.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: const Text(
          'Belum ada layanan yang dipilih.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final hasMoreServices = services.length > 8;
    final visibleServices =
        hasMoreServices ? services.take(7).toList() : services;
    final serviceItems = visibleServices.map((service) {
      return LayananItem(
        title: service.title,
        image: service.image,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: service.builder),
          );
        },
      );
    }).toList();

    if (hasMoreServices) {
      serviceItems.add(
        LayananItem(
          title: 'Lainnya',
          image: 'assets/images/grid_lainnya.png',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LayananLainScreen(services: services),
              ),
            );
          },
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: serviceItems,
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
