import 'package:flutter/material.dart';

class InfoHargaScreen extends StatefulWidget {
  const InfoHargaScreen({super.key});

  @override
  State<InfoHargaScreen> createState() => _InfoHargaScreenState();
}

class _InfoHargaScreenState extends State<InfoHargaScreen> {
  bool manfaatOpen = true;
  bool sistemOpen = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0047B3),

      body: Stack(
        children: [
          // HEADER BLUE
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
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),

                      const Expanded(
                        child: Center(
                          child: Text(
                            "Informasi",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // CONTENT
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                    ),

                    child: ListView(
                      children: [
                        // ======================
                        // IMAGE
                        // ======================
                        Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F9FF),
                            borderRadius: BorderRadius.circular(24),
                          ),

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              "assets/images/siskaperbapo.png",
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ======================
                        // TITLE
                        // ======================
                        const Text(
                          "Tentang Harga Bahan Pokok\n(SISKAPERBAPO)",
                          style: TextStyle(
                            fontSize: 20,
                            height: 1.4,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF121938),
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          "Portal info tren harga dan ketersediaan bahan pokok harian dari seluruh area di Jawa Timur.",
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 34),

                        // ======================
                        // OPERASIONAL
                        // ======================
                        const Text(
                          "Operasional",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF121938),
                          ),
                        ),

                        const SizedBox(height: 20),

                        _infoCard(
                          title: "Link Layanan",
                          child: const Text(
                            "https://siskaperbapo.jatimprov.go.id/",
                            style: TextStyle(
                              color: Color(0xFF0E63FF),
                              fontSize: 16,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        _infoCard(
                          title: "Alamat",
                          child: const Text(
                            "Jl. Siwalankerto Utara II/42 Surabaya",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),

                        const SizedBox(height: 16),

                        _infoCard(
                          title: "Jam Operasional",
                          child: const Text(
                            "Senin - Minggu (24 Jam)",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),

                        const SizedBox(height: 16),

                        _infoCard(
                          title: "Media Sosial",
                          child: const Row(
                            children: [
                              Icon(
                                Icons.play_circle_fill,
                                color: Color(0xFF0E63FF),
                              ),

                              SizedBox(width: 8),

                              Text(
                                "Youtube",
                                style: TextStyle(
                                  color: Color(0xFF0E63FF),
                                  fontSize: 16,
                                ),
                              ),

                              SizedBox(width: 24),

                              Icon(Icons.facebook, color: Color(0xFF0E63FF)),

                              SizedBox(width: 8),

                              Text(
                                "Facebook",
                                style: TextStyle(
                                  color: Color(0xFF0E63FF),
                                  fontSize: 16,
                                ),
                              ),

                              SizedBox(width: 24),

                              Icon(Icons.camera_alt, color: Color(0xFF0E63FF)),

                              SizedBox(width: 8),

                              Text(
                                "Instagram",
                                style: TextStyle(
                                  color: Color(0xFF0E63FF),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 36),

                        // ======================
                        // KETENTUAN
                        // ======================
                        const Text(
                          "Ketentuan Umum",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF121938),
                          ),
                        ),

                        const SizedBox(height: 20),

                        _accordionCard(
                          title: "Manfaat",
                          content:
                              "1. Akses informasi harga bahan pokok secara harian dan transparan.\n2. Pemantauan ketersediaan bahan pokok dengan mudah, kapan saja.\n3. Mendukung pengendalian inflasi dan menjaga stabilitas harga bahan pokok.",
                          isOpen: manfaatOpen,
                          onTap: () {
                            setState(() {
                              manfaatOpen = !manfaatOpen;
                            });
                          },
                        ),

                        const SizedBox(height: 18),

                        _accordionCard(
                          title: "Sistem, Mekanisme, dan Prosedur",
                          content:
                              "Sistem\n\nWebsite milik Disperindag Jatim yang menyediakan data harian harga dan ketersediaan bahan pokok secara detail.\n\nCek Harga Sembako Lewat SISKAPERBAPO\n\n1. Akses situs web resmi SISKAPERBAPO\n2. Telusuri data harga bahan pokok berdasarkan kategori bahan pokok.\n3. Pilih lokasi atau wilayah kabupaten/kota yang ingin dipantau.\n4. Lihat grafik tren harga harian dan informasi ketersediaan barang.\n5. Gunakan fitur perbandingan harga produsen dan konsumen untuk analisis.",
                          isOpen: sistemOpen,
                          onTap: () {
                            setState(() {
                              sistemOpen = !sistemOpen;
                            });
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
        ],
      ),
    );
  }

  Widget _infoCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF121938),
            ),
          ),

          const SizedBox(height: 18),

          child,
        ],
      ),
    );
  }

  Widget _accordionCard({
    required String title,
    required String content,
    required bool isOpen,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF121938),
                  ),
                ),
              ),

              GestureDetector(
                onTap: onTap,
                child: Text(
                  isOpen ? "—" : "+",
                  style: const TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
            ],
          ),

          if (isOpen) ...[
            const SizedBox(height: 20),

            Text(
              content,
              style: const TextStyle(
                height: 1.6,
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
