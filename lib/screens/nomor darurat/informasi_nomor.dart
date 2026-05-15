import 'package:flutter/material.dart';

class InfoNomorDaruratScreen extends StatefulWidget {
  const InfoNomorDaruratScreen({super.key});

  @override
  State<InfoNomorDaruratScreen> createState() => _InfoNomorDaruratScreenState();
}

class _InfoNomorDaruratScreenState extends State<InfoNomorDaruratScreen> {
  bool manfaatOpen = true;
  bool sistemOpen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0047B3),

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
                // ======================
                // APPBAR
                // ======================
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

                // ======================
                // CONTENT
                // ======================
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
                              "assets/images/nomordarurat.png",
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
                          "Tentang Nomor Darurat",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF121938),
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          "Temukan nomor kontak darurat Kabupaten/Kota di seluruh Jatim.",
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
                          title: "Alamat",
                          value: "Seluruh kota di Jawa Timur",
                        ),

                        const SizedBox(height: 16),

                        _infoCard(
                          title: "Jam Operasional",
                          value: "Senin - Minggu (24 Jam)",
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
                              "Layanan nomor darurat memberikan akses cepat dan mudah untuk mencari pertolongan saat seseorang mengalami atau mengetahui situasi darurat seperti kebakaran, banjir, kecelakaan lalu lintas, kriminalitas, dan lainnya. Dengan begitu, layanan ini diharapkan mampu mempercepat penanganan keadaan darurat dan meminimalisir dampak buruk yang muncul akibat situasi darurat.\n\nLayanan nomor darurat beroperasi 24 jam sehari, dan 7 hari seminggu. Sehingga masyarakat bisa mengaksesnya kapanpun dan dari manapun.",
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
                              "Kontak darurat biasanya lebih pendek atau sedikit dengan tujuan agar mudah diingat. Pastikan Anda menyimpan daftar kontak darurat di ponsel Anda atau tempat yang mudah dijangkau. Terakhir, pastikan Anda memberikan informasi secara jelas mengenai kejadian dan lokasinya agar petugas bisa mengeksekusinya lebih cepat.",
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

  Widget _infoCard({required String title, required String value}) {
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

          Text(value, style: const TextStyle(color: Colors.grey, fontSize: 16)),
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
