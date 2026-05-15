import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'detail_wisata_screen.dart';

class InformasiScreen extends StatefulWidget {
  const InformasiScreen({super.key});

  @override
  State<InformasiScreen> createState() => _InformasiScreenState();
}

class _InformasiScreenState extends State<InformasiScreen> {
  int selectedTab = 0;

  bool manfaatOpen = true;
  bool sistemOpen = true;

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
            height: 200,
            decoration: const BoxDecoration(
              color: Color(0xFF0D57E7),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
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
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.white),
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
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF2FF),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF0E63FF),
                                width: 1,
                              ),
                            ),
                            child: ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: Image.asset(
    "assets/images/sidita.png",
    width: double.infinity,
    height: 120, // bisa kamu adjust
    fit: BoxFit.cover,
  ),
),
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "Tentang Destinasi Wisata",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
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
                                fontWeight: FontWeight.bold),
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
                                fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 12),

                          _expandBox(
                            "Manfaat",
                            manfaatOpen,
                            () => setState(
                                () => manfaatOpen = !manfaatOpen),
                            "Aplikasi SIDITA (Sistem Informasi Daya Tarik Wisata) merupakan platform yang menyediakan layanan informasi terkait data kepariwisataan, khususnya di wilayah Jawa Timur. Manfaat yang diperoleh pengguna dari aplikasi ini antara lain:\n\n1. Data dan informasi valid\n2. Fitur maps dan direction ke destinasi tujuan\n3. Data diperbarui secara real time",
                          ),

                          _expandBox(
                            "Sistem, Mekanisme, dan Prosedur",
                            sistemOpen,
                            () => setState(
                                () => sistemOpen = !sistemOpen),
                            "Pengunjung perlu menyiapkan 3 hal ini untuk menikmati layanan 360 East Java Virtual Tour, seperti:\n1. Perangkat elektronik, berupa handphone atau laptop\n2. Koneksi internet stabil\n3. Browser yang update\n\nSistem\n\nLayanan SIDITA dilengkapi dengan 2 fitur, yaitu:\n1. SIDITA berbasis website untuk memudahkan pengunjung menikmati layanannya tanpa perlu instal aplikasi.\n2. Titik koordinat wisata sebagai panduan perjalanan ke lokasi tujuan",
                          ),
                        ],

                        // =========================
                        // TAB 2 (WISATA TERSIMPAN)
                        // =========================
                        if (selectedTab == 1) ...[
                          _savedCard(
                            "Gunung Bromo",
                            "Gunung Bromo adalah gunung Berapi aktif di Jawa Timur, Indonesia.",
                            "Kabupaten Probolinggo",
                            "assets/images/bromo.png",
                          ),
                          _savedCard(
                            "Kawah Ijen",
                            "Keindahan Kawah ijen dengan fenomena alam yang mendunia.",
                            "Kabupaten Banyuwangi",
                            "assets/images/kawah_ijen.png",
                          ),
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
            color: isActive
                ? const Color(0xFFDCE8FF)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? const Color(0xFF0E63FF)
                    : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _savedCard(
      String title, String desc, String location, String image) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const DetailWisataScreen(),
          ),
        );
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
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    image,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const Positioned(
                  top: 12,
                  right: 12,
                  child: Icon(Icons.favorite, color: Colors.white),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(desc,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Color(0xFF0E63FF)),
                      const SizedBox(width: 4),
                      Text(location,
                          style: const TextStyle(
                              color: Color(0xFF0E63FF))),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _infoBox(String title, String value,
      {bool isLink = false}) {
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
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: isLink ? () => _openLink(value) : null,
            child: Text(
              value,
              style: TextStyle(
                color: isLink
                    ? const Color(0xFF0E63FF)
                    : Colors.black,
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
      String title, bool isOpen, VoidCallback onTap, String content) {
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
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold)),
              IconButton(
                icon: Icon(
                    isOpen ? Icons.remove : Icons.add,
                    size: 18),
                onPressed: onTap,
              )
            ],
          ),
          if (isOpen)
            Text(content,
                style: const TextStyle(color: Colors.grey))
        ],
      ),
    );
  }
}