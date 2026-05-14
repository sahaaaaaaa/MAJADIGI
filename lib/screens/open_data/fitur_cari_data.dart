import 'package:flutter/material.dart';
import 'package:majadigi/screens/open_data/fitur_data_set.dart';
import 'package:majadigi/screens/open_data/fitur_detail_data_set.dart';
import 'open_data_dummy.dart';

class OpenDataCariDataScreen extends StatelessWidget {
  const OpenDataCariDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = dummyOpenData.first;
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7),

      body: Stack(
        children: [

          // BACKGROUND
          Container(
            width: double.infinity,
            height: 260,
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
                padding: const EdgeInsets.fromLTRB(18, 55, 18, 0),
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
                          "Cari Data",
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
              ),

              const SizedBox(height: 20),

              // CONTENT
              Expanded(
                child: Container(
                  width: double.infinity,

                  decoration: const BoxDecoration(
                    color: Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                  ),

                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // SEARCH
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                          ),

                          child: Row(
                            children: [

                              Icon(
                                Icons.search,
                                color: Colors.grey[500],
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Cari Data dan Informasi",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // STATISTIK
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio: 1.45,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,

                          children: [

                            _buildStatCard(
                              title: data.totalDataset.toString(),
                              subtitle: "Dataset",
                              color: Colors.blue,
                              icon: Icons.dataset_outlined,
                            ),

                            _buildStatCard(
                              title: data.totalPerangkatDaerah,
                              subtitle: "Perangkat Daerah",
                              color: Colors.purple,
                              icon: Icons.groups_outlined,
                            ),

                            _buildStatCard(
                              title: data.totalArtikel,
                              subtitle: "Artikel",
                              color: Colors.green,
                              icon: Icons.trending_up,
                            ),

                            _buildStatCard(
                              title: data.totalPengunjung,
                              subtitle: "Pengunjung",
                              color: Colors.orange,
                              icon: Icons.remove_red_eye_outlined,
                            ),

                            _buildStatCard(
                              title: data.totalInfografik,
                              subtitle: "Infografik",
                              color: Colors.red,
                              icon: Icons.image_outlined,
                            ),

                            _buildStatCard(
                              title: data.totalPublikasi,
                              subtitle: "Publikasi",
                              color: Colors.indigo,
                              icon: Icons.menu_book_outlined,
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // GRAFIK
                        const Text(
                          "Grafik Pengunjung",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        _buildChartCard(
                          color: Colors.blue,
                        ),

                        const SizedBox(height: 28),

                        const Text(
                          "Statistik Download",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        _buildChartCard(
                          color: Colors.green,
                        ),

                        const SizedBox(height: 30),

                        // TOPIK
                        const Text(
                          "Telusuri Data Berdasarkan Topik",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),

                        SizedBox(
                          height: 140,

                          child: ListView(
                            scrollDirection: Axis.horizontal,

                            children: [

                              _buildTopicItem(
                                title: "Ekonomi",
                                imagePath:
                                  "assets/images/openData/ekonomi.png",
                                onTap: () {
                                  // Navigasi ke halaman kategori Ekonomi
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FiturDataSetScreen(
                                        selectedKategori: "Ekonomi",
                                      ),
                                    ),
                                  );
                                },
                              ),

                              _buildTopicItem(
                                title: "Infrastruktur",
                                imagePath:
                                  "assets/images/openData/infrastruktur.png",
                                onTap: () {
                                  // Navigasi ke halaman kategori Infrastruktur
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FiturDataSetScreen(
                                        selectedKategori: "Infrastruktur",
                                      ),
                                    ),
                                  );
                                },
                              ),

                              _buildTopicItem(
                                title: "Kemiskinan",
                                imagePath:
                                  "assets/images/openData/kemiskinan.png",
                                onTap: () {
                                  // Navigasi ke halaman kategori Kemiskinan
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FiturDataSetScreen(
                                        selectedKategori: "Kemiskinan",
                                      ),
                                    ),
                                  );
                                },
                              ),

                              _buildTopicItem(
                                title: "Kependudukan",
                                imagePath:
                                    "assets/images/openData/kependudukan.png",
                                onTap: () {
                                  // Navigasi ke halaman kategori Kependudukan
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FiturDataSetScreen(
                                        selectedKategori: "Kependudukan",
                                      ),
                                    ),
                                  );
                                },
                              ),

                              _buildTopicItem(
                                title: "Kesehatan",
                                imagePath:
                                    "assets/images/openData/kesehatan.png",
                                onTap: () {
                                  // Navigasi ke halaman kategori Kesehatan
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FiturDataSetScreen(
                                        selectedKategori: "Kesehatan",
                                      ),
                                    ),
                                  );
                                },
                              ),

                              _buildTopicItem(
                                title: "Lingkungan Hidup",
                                imagePath:
                                    "assets/images/openData/lingkungan.png",
                                onTap: () {
                                  // Navigasi ke halaman kategori Lingkungan Hidup
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FiturDataSetScreen(
                                        selectedKategori: "Lingkungan Hidup",
                                      ),
                                    ),
                                  );
                                },
                              ),

                              _buildTopicItem(
                                title: "Pemerintah & Desa",
                                imagePath:
                                    "assets/images/openData/pemerintah.png",
                                onTap: () {
                                  // Navigasi ke halaman kategori Pemerintah & Desa
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FiturDataSetScreen(
                                        selectedKategori: "Pemerintah & Desa",
                                      ),
                                    ),
                                  );
                                },
                              ),

                              _buildTopicItem(
                                title: "Pendidikan",
                                imagePath:
                                    "assets/images/openData/pendidikan.png",
                                onTap: () {
                                  // Navigasi ke halaman kategori Pendidikan
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FiturDataSetScreen(
                                        selectedKategori: "Pendidikan",
                                      ),
                                    ),
                                  );
                                },
                              ),

                              _buildTopicItem(
                                title: "Sosial",
                                imagePath:
                                    "assets/images/openData/sosial.png",
                                onTap: () {
                                  // Navigasi ke halaman kategori Sosial
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FiturDataSetScreen(
                                        selectedKategori: "Sosial",
                                      ),
                                    ),
                                  );
                                },
                              ),

                              _buildTopicItem(
                                title: "Tata Ruang",
                                imagePath:
                                    "assets/images/openData/tataruang.png",
                                onTap: () {
                                  // Navigasi ke halaman kategori Tata Ruang
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FiturDataSetScreen(
                                        selectedKategori: "Tata Ruang",
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // HIGHLIGHT
                        const Text(
                          "Highlight Data",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Column(
                          children: dummyHighlightData.map((item) {
                            return _buildHighlightCard(
                              title: item.title,
                              instansi: item.instansi,
                              tahun: item.tahun,
                              kategori: item.kategori,
                              tanggal: item.tanggal,
                              status: item.status,

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FiturDetailDataSetScreen(
                                      item: item,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
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

  Widget _buildStatCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
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
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Icon(
                icon,
                color: color,
                size: 18,
              ),
            ],
          ),

          const Spacer(),

          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({
  required Color color,
}) {
  return Container(
    height: 260,
    padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
    ),

    child: Column(
      children: [

        Expanded(
          child: Stack(
            children: [

              // GRID
              Column(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: List.generate(
                  5,
                  (index) => Container(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                ),
              ),

              // CHART
              CustomPaint(
                size: const Size(double.infinity, 180),
                painter: ModernChartPainter(color),
              ),

              // LABEL Y
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 0,
                    top: 4,
                    bottom: 24,
                  ),

                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,

                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      _buildYLabel("4K"),
                      _buildYLabel("3K"),
                      _buildYLabel("2K"),
                      _buildYLabel("1K"),
                      _buildYLabel("500"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // LABEL X
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

            children: const [
              Text("Jan"),
              Text("Feb"),
              Text("Mar"),
              Text("Apr"),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildYLabel(String text) {
  return Text(
    text,
    style: TextStyle(
      color: Colors.grey[500],
      fontSize: 11,
    ),
  );
}

  Widget _buildTopicItem({
  required String title,
  required String imagePath,
  required VoidCallback onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(24),
    onTap: onTap,

    child: Container(
      width: 120,
      margin: const EdgeInsets.only(right: 14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),

      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Container(
              width: 58,
              height: 58,

              decoration: BoxDecoration(
                color: const Color(0xFFF4F6FA),
                shape: BoxShape.circle,
              ),

              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    )
  );
}

  Widget _buildHighlightCard({
    required String title,
    required String instansi,
    required String tahun,
    required String kategori,
    required String tanggal,
    required String status,
    required VoidCallback onTap,
  }) {

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [

                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blue.withOpacity(0.12),
                    child: const Icon(
                      Icons.apartment,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Text(
                instansi,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [

                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Colors.grey[600],
                  ),

                  const SizedBox(width: 6),

                  Text(
                    tahun,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(width: 20),

                  Icon(
                    Icons.grid_view_rounded,
                    size: 14,
                    color: Colors.grey[600],
                  ),

                  const SizedBox(width: 6),

                  Text(
                    kategori,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [

                  Icon(
                    Icons.access_time_filled,
                    size: 14,
                    color: Colors.grey[600],
                  ),

                  const SizedBox(width: 6),

                  Text(
                    tanggal,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(width: 20),

                  const Icon(
                    Icons.check_circle,
                    size: 14,
                    color: Colors.green,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    status,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

      

class ModernChartPainter extends CustomPainter {
  final Color color;

  ModernChartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.10)
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(30, 20);
    path.lineTo(size.width * 0.30, 60);
    path.lineTo(size.width * 0.50, 60);
    path.lineTo(size.width * 0.75, 130);
    path.lineTo(size.width - 10, 170);

    // FILL AREA
    final fillPath = Path.from(path)
      ..lineTo(size.width - 10, size.height)
      ..lineTo(30, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);

    // MAIN LINE
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}