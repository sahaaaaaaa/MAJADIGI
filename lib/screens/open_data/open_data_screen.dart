import 'package:flutter/material.dart';
import 'open_data_detail_screen.dart';
import 'open_data_dummy.dart';
import 'open_data_info_screen.dart';

class OpenDataScreen extends StatefulWidget {
  const OpenDataScreen({super.key});

  @override
  State<OpenDataScreen> createState() => _OpenDataScreenState();
}

class _OpenDataScreenState extends State<OpenDataScreen> {
  late PageController _pageController;
  int _activePage = 0;

  // Data dummy untuk gambar klarifikasi terbaru agar bervariasi
  final List<String> newsImages = [
    'assets/images/open_data_banner1.png',
    'assets/images/open_data_banner2.png', 
    'assets/images/open_data_banner3.png',
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
      backgroundColor: const Color(0xFF0D57E7),
      body: Stack(
        children: [
          // BACKGROUND
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
                              
                              // Kartu Layanan Open Data
                              _buildLayananCard(
                                icon: Icons.search_rounded,
                                title: "Cari Data",
                                desc: "Silahkan cari data yang Anda butuhkan mulai dari data pendidikan, kependudukan, dan lainnya.",
                                onTap: () {},
                              ),
                              const SizedBox(height: 16),
                              _buildLayananCard(
                                icon: Icons.storage_rounded,
                                title: "Data Set",
                                desc: "Temukan kumpulan data-data mentah yang bisa diolah lebih lanjut di sini.",
                                onTap: () {},
                              ),

                              const SizedBox(height: 35),
                              const Text("Statistik Open Data Jawa Timur", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              _buildStatistikGrid(),

                              const SizedBox(height: 35),
                              const Text("Infografis Terkini", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              _buildInfografisList(),

                              const SizedBox(height: 30),
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
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          ),
          const Text("Open Data", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Icon(Icons.bookmark_outline_rounded, color: Colors.white.withOpacity(0.9)),
              const SizedBox(width: 15),
              
              InkWell(
                onTap: () {
                  // Navigasi ke halaman OpenDataInformasiScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OpenDataInformasiScreen(),
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
      height: 480, // Ukuran proporsional sesuai gambar
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _activePage = index % newsImages.length),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              newsImages[index % newsImages.length], // Ini kuncinya
              fit: BoxFit.cover,
            ),
            ),
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

  Widget _buildLayananCard({required IconData icon, required String title, required String desc, required VoidCallback onTap}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFF0D57E7).withOpacity(0.1), shape: BoxShape.circle),
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
              onPressed: onTap,
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

  Widget _buildStatistikGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.7,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatItem("40.213", "Dataset"),
        _buildStatItem("64", "Perangkat Daerah"),
        _buildStatItem("22", "Artikel"),
        _buildStatItem("99.923", "Pengunjung"),
        _buildStatItem("506", "Infografik"),
        _buildStatItem("18", "Publikasi"),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D57E7))),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildInfografisList() {
  return Column(
    children: List.generate(newsImages.length, (index) {
      // Data dummy untuk dikirim ke halaman detail (opsional)
      String title = index == 0 
          ? "Realisasi Investasi Jawa Timur Tahun 2025" 
          : index == 1 
            ? "Data Kependudukan Berdasarkan Wilayah" 
            : "Publikasi Indeks Pembangunan Manusia";

      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        // Gunakan ClipRRect agar efek InkWell tidak keluar dari border radius
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: InkWell(
            onTap: () {
              // Navigasi ke halaman detail
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OpenDataDetailScreen(
                  data: dummyOpenData[index],
                ),
                  // Kalau mau kirim data, tambahkan constructor di OpenDataDetailScreen
                  // builder: (context) => OpenDataDetailScreen(title: title, image: newsImages[index]),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bagian Gambar
                Image.asset(
                  newsImages[index],
                  height: 200, 
                  width: double.infinity, 
                  fit: BoxFit.cover,
                ),
                
                // Bagian Teks
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D57E7).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          "Statistik", 
                          style: TextStyle(
                            color: Color(0xFF0D57E7), 
                            fontSize: 11, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 14, 
                          height: 1.4
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }),
  );
}

  Widget _buildLargeMoreButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
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

