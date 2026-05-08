import 'package:flutter/material.dart';

class KlinikHoaksInformasiScreen extends StatefulWidget {
  const KlinikHoaksInformasiScreen({super.key});

  @override
  State<KlinikHoaksInformasiScreen> createState() =>
      _KlinikHoaksInformasiScreenState();
}

class _KlinikHoaksInformasiScreenState
    extends State<KlinikHoaksInformasiScreen> {

  bool manfaatExpanded = false;
  bool daftarExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7),

      body: Stack(
        children: [

          // BACKGROUND HEADER
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/latar_belakang.png',
                ),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          Column(
            children: [

              // APPBAR
              _buildAppBar(),

              const SizedBox(height: 10),

              // MAIN CONTAINER
              Expanded(
                child: Container(
                  width: double.infinity,

                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),

                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // HANDLE
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // BANNER
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 25),

                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.shade50,
                                Colors.blue.shade100,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.blue.shade100,
                            ),
                          ),

                          child: Center(
                            child: Image.asset(
                              'assets/images/logo_jatim.png',
                              height: 80,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // TENTANG
                        const Text(
                          "Tentang Klinik Hoaks",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          "Platform layanan publik yang dibangun oleh Dinas "
                          "Komunikasi dan Informatika Provinsi Jawa Timur "
                          "untuk membantu masyarakat memverifikasi "
                          "kebenaran informasi beredar, terutama soal "
                          "berita hoaks.",
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.7,
                            color: Colors.grey[700],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // OPERASIONAL
                        const Text(
                          "Operasional",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),

                        _buildInfoCard(
                          title: "Link Layanan",
                          child: Text(
                            "https://klinikhoaks.jatimprov.go.id/",
                            style: TextStyle(
                              color: Colors.blue[700],
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                        _buildInfoCard(
                          title: "Alamat",
                          child: const Text(
                            "Jl. A. Yani 242 - 244, Gayungan, Surabaya.",
                          ),
                        ),

                        _buildInfoCard(
                          title: "Jam Operasional",
                          child: const Text(
                            "Senin - Minggu (24 Jam)",
                          ),
                        ),

                        _buildInfoCard(
                          title: "Media Sosial",
                          child: Row(
                            children: [

                              Icon(
                                Icons.play_circle_fill,
                                color: Colors.blue[700],
                              ),

                              const SizedBox(width: 6),

                              const Text("Youtube"),

                              const SizedBox(width: 24),

                              Icon(
                                Icons.camera_alt,
                                color: Colors.blue[700],
                              ),

                              const SizedBox(width: 6),

                              const Text("Instagram"),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // KETENTUAN
                        const Text(
                          "Ketentuan Umum",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),

                        _buildExpandTile(
                          title: "Manfaat",
                          isExpanded: manfaatExpanded,
                          onTap: () {
                            setState(() {
                              manfaatExpanded = !manfaatExpanded;
                            });
                          },
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("1. Membantu masyarakat memverifikasi informasi."),
                              SizedBox(height: 8),
                              Text("2. Melindungi publik dari informasi palsu."),
                              SizedBox(height: 8),
                              Text("3. Meningkatkan literasi digital."),
                              SizedBox(height: 8),
                              Text("4. Mendukung ruang digital sehat."),
                              SizedBox(height: 8),
                              Text("5. Transparansi hasil verifikasi."),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        _buildExpandTile(
                          title: "Pendaftaran Online",
                          isExpanded: daftarExpanded,
                          onTap: () {
                            setState(() {
                              daftarExpanded = !daftarExpanded;
                            });
                          },
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("1. Akses website Klinik Hoaks."),
                              SizedBox(height: 8),
                              Text("2. Masukkan kata kunci informasi."),
                              SizedBox(height: 8),
                              Text("3. Sistem akan menampilkan hasil."),
                              SizedBox(height: 8),
                              Text("4. Jika tidak ditemukan, kirim klarifikasi."),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),
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

  // APPBAR
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 55, 16, 0),
      child: Row(
        children: [

          InkWell(
            onTap: () => Navigator.pop(context),

            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                "Informasi",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),
        ],
      ),
    );
  }

  // INFO CARD
  Widget _buildInfoCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),

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
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          child,
        ],
      ),
    );
  }

  // EXPAND TILE
  Widget _buildExpandTile({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Column(
        children: [

          InkWell(
            onTap: onTap,

            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),

              child: Row(
                children: [

                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Icon(
                    isExpanded ? Icons.remove : Icons.add,
                  ),
                ],
              ),
            ),
          ),

          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              child: content,
            ),
        ],
      ),
    );
  }
}