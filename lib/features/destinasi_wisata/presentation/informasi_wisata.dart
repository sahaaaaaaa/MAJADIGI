import 'package:flutter/material.dart';
import 'package:majadigi/features/destinasi_wisata/data/destinasi_wisata_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:majadigi/features/destinasi_wisata/presentation/detail_wisata_screen.dart';

class InformasiScreen extends StatefulWidget {
  const InformasiScreen({super.key});

  @override
  State<InformasiScreen> createState() => _InformasiScreenState();
}

class _InformasiScreenState extends State<InformasiScreen> {
  late final DestinasiWisataService _wisataService;
  int selectedTab = 0;

  bool manfaatOpen = false;
  bool sistemOpen = false;
  bool _isLoadingFavorites = true;
  String? _favoriteError;
  List<WisataFavorite> _favorites = [];

  @override
  void initState() {
    super.initState();
    _wisataService = DestinasiWisataService();
    _loadFavorites();
  }

  @override
  void dispose() {
    _wisataService.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoadingFavorites = true;
      _favoriteError = null;
    });

    try {
      final favorites = await _wisataService.getFavorites();
      if (!mounted) {
        return;
      }
      setState(() {
        _favorites = favorites;
        _isLoadingFavorites = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoadingFavorites = false;
        _favoriteError = "Wisata tersimpan belum dapat dimuat.";
      });
    }
  }

  void _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Stack(
        children: [
          // HEADER
          Container(
            height: 250,

            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),

              image: DecorationImage(
                image: AssetImage("assets/images/latar_belakang.png"),

                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // APPBAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Informasi",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      children: [
                        // TAB
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9EEF6),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              _tabButton("Tentang Layanan", 0),
                              _tabButton("Wisata Tersimpan", 1),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // =========================
                        // TAB 1
                        // =========================
                        if (selectedTab == 0) ...[
                          // 🔥 TOP IMAGE
                          Container(
                            width: double.infinity,
                            height: 160,

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),

                              image: const DecorationImage(
                                image: AssetImage('assets/images/sidita.svg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "Tentang Destinasi Wisata",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            "Sistem Informasi Daya Tarik Wisata (SIDITA), platform berbasis web untuk media promosi dan informasi destinasi, event, serta akomodasi hotel yang tersebar di Jawa Timur.",
                            style: TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "Operasional",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          _infoBox(
                            "Link Layanan",
                            "https://klinikhoaks.jatimprov.go.id/",
                            isLink: true,
                          ),

                          _infoBox(
                            "Alamat",
                            "Jl. A. Yani 242 - 244, Gayungan, Surabaya.",
                          ),

                          _infoBox(
                            "Jam Operasional",
                            "Senin - Minggu (24 Jam)",
                          ),

                          _socialBox(),

                          const SizedBox(height: 20),

                          const Text(
                            "Ketentuan Umum",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          _expandBox(
                            "Manfaat",
                            manfaatOpen,
                            () => setState(() => manfaatOpen = !manfaatOpen),
                            "Aplikasi SIDITA (Sistem Informasi Daya Tarik Wisata) merupakan platform yang menyediakan layanan informasi terkait data kepariwisataan, khususnya di wilayah Jawa Timur. Manfaat yang diperoleh pengguna dari aplikasi ini antara lain:\n\n1. Data dan informasi valid\n2. Fitur maps dan direction ke destinasi tujuan\n3. Data diperbarui secara real time",
                          ),

                          _expandBox(
                            "Sistem, Mekanisme, dan Prosedur",
                            sistemOpen,
                            () => setState(() => sistemOpen = !sistemOpen),
                            "Pengunjung perlu menyiapkan 3 hal ini untuk menikmati layanan 360 East Java Virtual Tour, seperti:\n1. Perangkat elektronik, berupa handphone atau laptop\n2. Koneksi internet stabil\n3. Browser yang update\n\nSistem\n\nLayanan SIDITA dilengkapi dengan 2 fitur, yaitu:\n1. SIDITA berbasis website untuk memudahkan pengunjung menikmati layanannya tanpa perlu instal aplikasi.\n2. Titik koordinat wisata sebagai panduan perjalanan ke lokasi tujuan",
                          ),
                        ],

                        // =========================
                        // TAB 2 (WISATA TERSIMPAN)
                        // =========================
                        if (selectedTab == 1) ...[
                          if (_isLoadingFavorites)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (_favoriteError != null)
                            _emptyFavoriteBox(_favoriteError!)
                          else if (_favorites.isEmpty)
                            _emptyFavoriteBox("Belum ada wisata tersimpan.")
                          else
                            ..._favorites.map(_savedCard),
                        ],
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

  // TAB BUTTON
  Widget _tabButton(String text, int index) {
    final isActive = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFDCE8FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive ? const Color(0xFF0E63FF) : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _savedCard(WisataFavorite favorite) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => DetailWisataScreen(
              destinationId: favorite.id,
              favorite: favorite,
            ),
          ),
        );
        if (!mounted || result != false) {
          return;
        }
        setState(() {
          _favorites = _favorites
              .where((item) => item.id != favorite.id)
              .toList();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: _wisataImage(
                    favorite.thumbnail,
                    height: 180,
                    width: double.infinity,
                  ),
                ),
                const Positioned(
                  top: 12,
                  right: 12,
                  child: Icon(Icons.favorite, color: Color(0xFFE53935)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    favorite.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    favorite.city,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Color(0xFF0E63FF),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        favorite.city,
                        style: const TextStyle(color: Color(0xFF0E63FF)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wisataImage(
    String image, {
    required double height,
    required double width,
  }) {
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return Image.network(
        image,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/images/bromo.png",
            height: height,
            width: width,
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Image.asset(
      image.isEmpty ? "assets/images/bromo.png" : image,
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }

  Widget _emptyFavoriteBox(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.grey[700], fontSize: 13),
      ),
    );
  }

  Widget _infoBox(String title, String value, {bool isLink = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: isLink ? () => _openLink(value) : null,
            child: Text(
              value,
              style: TextStyle(
                color: isLink ? const Color(0xFF0E63FF) : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialBox() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: const [
          Icon(Icons.play_circle_fill, color: Colors.red),
          SizedBox(width: 10),
          Text("Youtube"),
          SizedBox(width: 20),
          Icon(Icons.camera_alt, color: Colors.blue),
          SizedBox(width: 10),
          Text("Instagram"),
        ],
      ),
    );
  }

  Widget _expandBox(
    String title,
    bool isOpen,
    VoidCallback onTap,
    String content,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(isOpen ? Icons.remove : Icons.add, size: 18),
                onPressed: onTap,
              ),
            ],
          ),
          if (isOpen) Text(content, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
