import 'package:flutter/material.dart';
import 'klinik_hoax_layanan_screen.dart';
import 'klinik_hoax_detail_screen.dart';
import 'klinik_hoax_info_screen.dart';

class KlinikHoaksHomeScreen extends StatefulWidget {
  const KlinikHoaksHomeScreen({super.key});

  @override
  State<KlinikHoaksHomeScreen> createState() => _KlinikHoaksHomeScreenState();
}

class _KlinikHoaksHomeScreenState extends State<KlinikHoaksHomeScreen> {
  late PageController _pageController;
  int _activePage = 0;

  // Data dummy untuk gambar klarifikasi terbaru agar bervariasi
  final List<String> newsImages = [
    'assets/images/banner_hoax.png',
    'assets/images/banner_hoax.png', // Ganti dengan path news2.png dsb jika ada
    'assets/images/banner_hoax.png',
  ];

  @override
  void initState() {
    super.initState();
    // 1. Slider mulai dari tengah (index 1000 agar infinite) dan viewportFraction 0.8
    _pageController = PageController(viewportFraction: 0.82, initialPage: 999); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7), // Warna dasar tema
      body: Stack(
        children: [
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

          Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // 2. Slider dengan sudut membulat (ClipRRect)
                      _buildInfiniteSlider(),
                      const SizedBox(height: 15),
                      _buildPageIndicator(),
                      const SizedBox(height: 25),

                      // Container Putih Utama
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Layanan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              _buildLayananCard(
                                icon: Icons.volume_up_rounded,
                                title: "Laporan Hoaks",
                                desc: "Kirim info yang Kamu temukan, Kami bantu klarifikasi dalam 1x24 jam.",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const KlinikHoaksLayananScreen(initialTab: 0),
                                    ),
                                  );
                                }, 
                              ),
                              const SizedBox(height: 16),
                              _buildLayananCard(
                                icon: Icons.person_search_rounded,
                                title: "Lacak tiket Laporan",
                                desc: "Pantau status permohonan klarifikasi yang telah diajukan secara real time.",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const KlinikHoaksLayananScreen(initialTab: 1),
                                    ),
                                  );
                                },
                              ),
                              
                              const SizedBox(height: 35),
                              const Text("Rekap Hoaks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              // 3. Ikon Rekap Hoaks diperbaiki
                              _buildRekapGrid(),

                              const SizedBox(height: 35),
                              const Text("Klarifikasi Terbaru", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              // 4. News List dengan Center Alignment
                              _buildNewsList(),

                              const SizedBox(height: 30),
                              // 5. Tombol Berita Lainnya diperbesar
                              _buildLargeMoreButton(),
                              const SizedBox(height: 50),
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
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Row(
              children: [
                Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                SizedBox(width: 8),
              ],
            ),
          ),
          const Text("Klinik Hoaks", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Icon(Icons.bookmark_outline_rounded, color: Colors.white.withOpacity(0.9)),
              const SizedBox(width: 15),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const KlinikHoaksInformasiScreen(),
                    ),
                  );
                },
                child: Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfiniteSlider() {
    return SizedBox(
      height: 500, // Sesuaikan tinggi banner
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _activePage = index % 3),
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Membulat di ujung
                  child: Image.asset(
                    'assets/images/banner_hoax.png',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 6,
        width: _activePage == index ? 24 : 12,
        decoration: BoxDecoration(
          color: _activePage == index ? Colors.white : Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
        ),
      )),
    );
  }

  Widget _buildLayananCard({
  required IconData icon, 
  required String title, 
  required String desc,
  required VoidCallback onTap, // Tambahkan parameter ini
}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03), 
          blurRadius: 10, 
          offset: const Offset(0, 5)
        )
      ]
    ),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0D57E7).withOpacity(0.1), 
                shape: BoxShape.circle
              ),
              child: Icon(icon, color: const Color(0xFF0D57E7), size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onTap, // Gunakan parameter onTap di sini
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D57E7),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Selengkapnya", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        )
      ],
    ),
  );
}

  Widget _buildRekapGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatCard("347", "Berita Hoaks", Icons.chat_bubble_rounded, Colors.brown),
        _buildStatCard("25", "Disinformasi", Icons.campaign_rounded, Colors.orange),
        _buildStatCard("21", "Fakta", Icons.check_circle_rounded, Colors.green),
        _buildStatCard("0", "Hate Speech", Icons.gavel_rounded, Colors.red),
      ],
    );
  }

  Widget _buildStatCard(String val, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(val, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
              Icon(icon, size: 18, color: color.withOpacity(0.5)),
            ],
          ),
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
  return Column(
    children: List.generate(
      3,
      (index) => GestureDetector(

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const KlinikHoaksDetailScreen(),
            ),
          );
        },

        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
          ),

          child: Column(
            children: [

              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),

                child: Image.asset(
                  newsImages[index],
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(15),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "Dubes AS & Gus Yahya Ajak Umat Islam Kecam Tindakan Iran",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,

                      children: [

                        Text(
                          "08 April 2026",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                          ),
                        ),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),

                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red,
                            ),

                            borderRadius:
                                BorderRadius.circular(5),
                          ),

                          child: const Text(
                            "Hoaks",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildLargeMoreButton() {
    return SizedBox(
      width: double.infinity,
      height: 55, // Ukuran lebih besar sesuai referensi
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: const Text("Berita Lainnya", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
      ),
    );
  }
}