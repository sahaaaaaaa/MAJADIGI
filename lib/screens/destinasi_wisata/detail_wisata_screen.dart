import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailWisataScreen extends StatelessWidget {
  const DetailWisataScreen({super.key});

  final String mapsUrl = "https://maps.app.goo.gl/CNFKMwNEB9RgyXB89";

  void _openMaps() async {
    final Uri url = Uri.parse(mapsUrl);
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          // 🔥 STICKY HEADER + IMAGE
          Stack(
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

              SafeArea(
                child: Column(
                  children: [
                    // APPBAR
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Expanded(
                            child: Center(
                              child: Text(
                                "Gunung Bromo",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // IMAGE
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          "assets/images/bromo.png",
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // INFO CARD
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Gunung Bromo",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: const [
                                Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text("4.8 (100+)"),
                                SizedBox(width: 12),
                                Icon(
                                  Icons.location_on,
                                  color: Color(0xFF0E63FF),
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text("Kabupaten Probolinggo"),
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

          // 🔥 SCROLL AREA
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // FOTO
                const Text(
                  "Foto",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _fotoItem("assets/images/bromo.png"),
                      _fotoItem("assets/images/bromo2.png"),
                      _fotoItem("assets/images/bromo3.png"),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // LOKASI
                const Text(
                  "Lokasi",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: _openMaps,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/maps.png",
                          height: 240,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text("Gunung Bromo"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // DETAIL INFO
                const Text(
                  "Detail Informasi",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                _infoCard("Kabupaten/Kota", "Kabupaten Probolinggo"),
                _infoCard(
                  "Alamat",
                  "Cemoro Lawang, Desa Ngadisari, Kec. Sukapura, Kabupaten Probolinggo",
                ),
                _infoCard("Titik Koordinat", "-7.9324305, 112.9531326"),

                // STATUS
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Status",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Buka",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // FOTO ITEM
  Widget _fotoItem(String image) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(image, width: 220, fit: BoxFit.cover),
      ),
    );
  }

  // 🔥 FIXED INFO CARD (SESUAI REQUEST)
  Widget _infoCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 JUDUL BOLD
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 4),

          // 🔥 ISI NORMAL
          Text(value, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }
}
