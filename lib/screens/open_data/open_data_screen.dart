import 'package:flutter/material.dart';
import 'open_data_detail_screen.dart';

class OpenDataScreen extends StatelessWidget {
  const OpenDataScreen({super.key});

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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 55, 16, 0),

                child: Row(
                  children: [

                    InkWell(
                      onTap: () => Navigator.pop(context),

                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),

                    const Expanded(
                      child: Center(
                        child: Text(
                          "Open Data",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),

                    const Icon(
                      Icons.bookmark_outline,
                      color: Colors.white,
                    ),

                    const SizedBox(width: 14),

                    const Icon(
                      Icons.info_outline,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // MAIN CONTENT
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
                    padding: const EdgeInsets.all(20),

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

                        const SizedBox(height: 24),

                        // HERO IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),

                          child: Image.asset(
                            'assets/images/open_data_banner.png',
                            height: 260,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          "Layanan",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // CARD
                        _buildLayananCard(
                          title: "Cari Data",
                          desc:
                              "Silahkan cari data yang Anda butuhkan.",
                        ),

                        const SizedBox(height: 16),

                        _buildLayananCard(
                          title: "Data Set",
                          desc:
                              "Temukan kumpulan data-data mentah.",
                        ),

                        const SizedBox(height: 28),

                        const Text(
                          "Statistik Open Data Jawa Timur",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),

                        GridView.count(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),

                          crossAxisCount: 2,
                          childAspectRatio: 1.4,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,

                          children: const [

                            _StatCard(
                              number: "40.213",
                              label: "Dataset",
                            ),

                            _StatCard(
                              number: "64",
                              label: "Perangkat Daerah",
                            ),

                            _StatCard(
                              number: "22",
                              label: "Artikel",
                            ),

                            _StatCard(
                              number: "99.923",
                              label: "Pengunjung",
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        const Text(
                          "Infografis Terkini",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),

                        _buildNewsCard(
                          context,
                          image:
                              'assets/images/info1.png',
                          title:
                              'Realisasi Investasi Jawa Timur Tahun 2025 Tembus Rp. 147,7 Triliun',
                        ),

                        _buildNewsCard(
                          context,
                          image:
                              'assets/images/info2.png',
                          title:
                              'Inflasi Jatim Terkendali di Desember 2025',
                        ),

                        _buildNewsCard(
                          context,
                          image:
                              'assets/images/info3.png',
                          title:
                              'Prediksi Puncak Arus Balik Lebaran',
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 52,

                          child: OutlinedButton(
                            onPressed: () {},

                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(30),
                              ),
                            ),

                            child: const Text(
                              "Berita Lainnya",
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
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

  static Widget _buildLayananCard({
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            desc,
            style: TextStyle(
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 45,

            child: ElevatedButton(
              onPressed: () {},

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D57E7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),

              child: const Text(
                "Selengkapnya",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(
    BuildContext context, {
    required String image,
    required String title,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const OpenDataDetailScreen(),
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),

              child: Image.asset(
                image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.blue,
                      ),
                    ),

                    child: const Text(
                      "Ekonomi",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 11,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String number;
  final String label;

  const _StatCard({
    required this.number,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            number,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D57E7),
            ),
          ),

          const SizedBox(height: 8),

          Text(label),
        ],
      ),
    );
  }
}