import 'package:flutter/material.dart';

class KlinikHoaksDetailScreen extends StatelessWidget {
  const KlinikHoaksDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan warna biru sebagai background dasar agar saat scroll tidak putih di atas
      backgroundColor: const Color(0xFF0D57E7),
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE/COLOR (Paling Bawah)
          Container(
            width: double.infinity,
            height: 300, // Tinggi area biru
            decoration: const BoxDecoration(
              color: Color(0xFF0D57E7), // Warna fallback
              image: DecorationImage(
                image: AssetImage('assets/images/latar_belakang.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          // 2. KONTEN UTAMA (Header + Scrollable White Area)
          Column(
            children: [
              const SizedBox(height: 10),
              
              // HEADER (Tombol Kembali)
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10), 
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  label: const Text(
                    "Kembali",
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white, // Efek warna saat ditekan
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ),
              ),
             

              const SizedBox(height: 20),

              // AREA PUTIH (Menggunakan Expanded agar mengisi sisa layar)
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // GAMBAR BANNER (Sesuai gambar di HP)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/banner_hoax.png',
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // TANGGAL & LABEL HOAKS
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            const Text(
                              "08 April 2026",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red),
                              ),
                              child: const Text(
                                "Hoaks",
                                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // JUDUL
                        const Text(
                          "Dubes AS & Gus Yahya Ajak Umat Islam Kecam Tindakan Iran",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ISI KONTEN
                        Text(
                          "Beredar unggahan di media sosial yang menampilkan pertemuan antara Duta Besar Amerika Serikat dan Ketua Umum PBNU...\n\n"
                          "Faktanya, pertemuan antara Duta Besar Amerika Serikat dan Gus Yahya memang terjadi, namun isi pembahasannya berbeda jauh dari narasi yang beredar.",
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}