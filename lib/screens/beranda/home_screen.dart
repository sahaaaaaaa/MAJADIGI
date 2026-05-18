import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'layanan_lain.dart';
import 'layanan_daerah.dart';
import '../../widgets/layanan_item.dart';

import '../destinasi_wisata/destinasi_wisata_screen.dart';
import '../harga_barang/harga_bahan_pokok_screen.dart';
import '../klinik_hoax/klinik_hoax_home_screen.dart';
import '../open_data/open_data_screen.dart';
import '../rsud_provjatim/rsud_jatim.dart';
import '../rssa/rssa_screen.dart';
import '../transjatim/transjatim_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _controller = PageController();
  int _currentPage = 1;

  final List<String> banners = [
    "assets/images/welcome_hero2.jpg",
    "assets/images/welcome_hero.png",
    "assets/images/welcome_hero3.jpg",
  ];
  String selectedDaerah = "Jawa Timur";

final List<String> daerahList = [
  "Jawa Timur",
  "Kabupaten Banyuwangi",
  "Kabupaten Tuban",
  "Kota Surabaya",
  "Kabupaten Lamongan",
  "Kabupaten Tulungagung",
  "Kota Mojokerto",
  "Kota Probolinggo",
  "Kabupaten Jember",
  "Kabupaten Nganjuk",
  "Kabupaten Situbondo",
  "Kota Batu",
  "Kota Blitar",
  "Kabupaten Gresik",
];

  @override
  void initState() {
    super.initState();

    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller.hasClients) {
        _currentPage = (_currentPage + 1) % banners.length;

        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Stack(
        children: [
          // HEADER BACKGROUND
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
                // HEADER TOP
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.blue),
                      ),

                      const SizedBox(width: 12),

                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selamat Datang",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),

                          Text(
                            "Arief W.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      const Icon(Icons.search, color: Colors.white),

                      const SizedBox(width: 12),

                      const Icon(Icons.notifications_none, color: Colors.white),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // SLIDER
                SizedBox(
                  height: 180,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: banners.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _bannerImage(banners[index]);
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // DOT INDICATOR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    banners.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // MAIN CONTENT
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      children: [
                        // TITLE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Layanan",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LayananLainScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Semua layanan",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // GRID MENU
                        GridView.count(
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            LayananItem(
                              title: "Klinik Hoaks",
                              image: "assets/images/klinik_hoax.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const KlinikHoaksHomeScreen(),
                                  ),
                                );
                              },
                            ),

                            LayananItem(
                              title: "Destinasi Wisata",
                              image: "assets/images/destinasi_wisata.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const DestinasiWisataScreen(),
                                  ),
                                );
                              },
                            ),

                            LayananItem(
                              title: "Open Data",
                              image: "assets/images/open_data.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const OpenDataScreen(),
                                  ),
                                );
                              },
                            ),

                            LayananItem(
                              title: "Harga",
                              image: "assets/images/khas_jatim.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const HargaBahanPokokScreen(),
                                  ),
                                );
                              },
                            ),

                            LayananItem(
                              title: "RSUD Haji",
                              image: "assets/images/rsud_haji.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RsudHajiScreen(),
                                  ),
                                );
                              },
                            ),

                            LayananItem(
                              title: "Transjatim",
                              image: "assets/images/transjatim_ajaib.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TransjatimScreen(),
                                  ),
                                );
                              },
                            ),

                            LayananItem(
                              title: "RSSA",
                              image: "assets/images/rsud_saifulanwar.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RssaScreen(),
                                  ),
                                );
                              },
                            ),

                            LayananItem(
                              title: "Lainnya",
                              image: "assets/images/grid_lainnya.png",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LayananLainScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // JATIM DALAM ANGKA
                        const Text(
                          "Jatim Dalam Angka",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Row(
                          children: const [
                            Expanded(
                              child: _StatCard(
                                "42.089.271",
                                "Jumlah Penduduk",
                                "assets/images/icon_user.png",
                              ),
                            ),

                            SizedBox(width: 12),

                            Expanded(
                              child: _StatCard(
                                "0,73 %",
                                "Pertumbuhan Penduduk",
                                "assets/images/icon_penduduk.png",
                              ),
                            ),

                            SizedBox(width: 12),

                            Expanded(
                              child: _StatCard(
                                "9,56 %",
                                "Presentase Penduduk Miskin",
                                "assets/images/icon_ekonomi.png",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // LAYANAN DAERAH
                       // LAYANAN DAERAH
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: const [
        Icon(
          Icons.layers_outlined,
          color: Color(0xFFFF2E63),
          size: 20,
        ),

        SizedBox(width: 8),

        Text(
          "Layanan Daerah",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),

    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const SemuaLayananDaerahScreen(),
          ),
        );
      },
      child: const Text(
        "Lihat semua",
        style: TextStyle(color: Colors.blue),
      ),
    ),
  ],
),

const SizedBox(height: 16),

Wrap(
  spacing: 10,
  runSpacing: 10,
  children: [
    _chip("Jawa Timur", true),

    _chip("Kabupaten Banyuwangi", false),

    _chip("Kabupaten Tuban", false),

    _chip("Kota Surabaya", false),

    _chip("Kabupaten Lamongan", false),

    _chip("Kabupaten Tulungagung", false),
  ],
),
const SizedBox(height: 20),

const SizedBox(height: 20),

ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: Image.asset(
    "assets/images/mapsjatim.png",
    height: 220,
    width: double.infinity,
    fit: BoxFit.cover,
  ),
),

const SizedBox(height: 20),

_serviceItem(
  "assets/images/logo_majadigi.png",
  "Paket Kunjungan Agrowisata",
),

_serviceItem(
  "assets/images/islamic_center.png",
  "Islamic Center",
),

_serviceItem(
  "assets/images/open_data.png",
  "Badan Pendapatan Daerah (BAPENDA) Jawa Timur",
),

_serviceItem(
  "assets/images/logo_majadigi.png",
  "Data Penerima & Info Program Bansos (SAPA BANSOS)",
),

_serviceItem(
  "assets/images/rsud_haji.png",
  "RS Paru Manguharjo Provinsi Jawa Timur",
),

_serviceItem(
  "assets/images/rs_jember.png",
  "RS Paru Jember",
),

_serviceItem(
  "assets/images/logo_majadigi.png",
  "Forum Konsultasi Disnak Jatim",
),

_serviceItem(
  "assets/images/rumah_asn.png",
  "Rumah ASN",
),

_serviceItem(
  "assets/images/rsud_haji.png",
  "RSUD Haji Prov. Jatim",
),

_serviceItem(
  "assets/images/logo_majadigi.png",
  "SIMPEL K3 (Sistem Pelayanan K3L)",
),

_serviceItem(
  "assets/images/beasiswa.png",
  "Beasiswa LPPD Jatim",
),

const SizedBox(height: 20),

Row(
  children: [
    Expanded(
      child: _CategoryCard(
        image: "assets/images/mpp.png",
        title: "Mall Pelayanan Publik (MPP)",
        subtitle: "15 Mall Pelayanan Publik (MPP)",
      ),
    ),

    const SizedBox(width: 14),

    Expanded(
      child: _CategoryCard(
        image: "assets/images/rs.png",
        title: "Rumah Sakit",
        subtitle: "8 Rumah Sakit",
      ),
    ),

    const SizedBox(width: 14),

    Expanded(
      child: _CategoryCard(
        image: "assets/images/sma.png",
        title: "SMA/SMK",
        subtitle: "",
      ),
    ),
  ],
),
  
                        const SizedBox(height: 30),

                        // AGENDA
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.campaign_outlined,
                                  color: Color(0xFFFF2E63),
                                  size: 20,
                                ),

                                SizedBox(width: 8),

                                Text(
                                  "Agenda Jawa Timur",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const Text(
                              "Lihat semua",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        _agendaCard(
                          title: "BAHANA BERSAHAJA",
                          location: "Kabupaten Madiun",
                        ),

                        const SizedBox(height: 14),

                        _agendaCard(
                          title: "Gelar kesenian dan Pameran Produk Ekraf",
                          location: "Kabupaten Tulungagung",
                        ),

                        const SizedBox(height: 14),

                        _agendaCard(
                          title: "Vespa Portugis",
                          location: "Kabupaten Kediri",
                        ),

                        const SizedBox(height: 30),

                        // BERITA
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.newspaper,
                                  color: Color(0xFFFF2E63),
                                  size: 20,
                                ),

                                SizedBox(width: 8),

                                Text(
                                  "Berita Jawa Timur",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const Text(
                              "Lihat semua",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          height: 260,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _newsCard(
                                "assets/images/berita1.png",
                                "Kepala Bakorwil Malang Hadiri Pelantikan DPD IKADIN Jatim",
                                "https://kominfo.jatimprov.go.id/berita/kepala-bakorwil-malang-hadiri-pelantikan-dpd-ikadin-jatim",
                              ),

                              const SizedBox(width: 14),

                              _newsCard(
                                "assets/images/berita2.png",
                                "Gubernur Khofifah Apresiasi Mitra Usaha pada 50 Tahun PT Dharma Lautan Utama",
                                "https://kominfo.jatimprov.go.id/berita/gubernur-khofifah-apresiasi-mitra-usaha-pada-50-tahun-pt-dharma-lautan-utama",
                              ),

                              const SizedBox(width: 14),

                              _newsCard(
                                "assets/images/berita3.png",
                                "Jaga Infrastruktur Sumber Daya Air",
                                "https://kominfo.jatimprov.go.id/berita/jaga-infrastruktur-sumber-daya-air-pjt-i-jadwalkan-flushing-bendungan-wlingi-dan-lodoyo",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // CUACA
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.wb_sunny_outlined,
                                  color: Color(0xFFFF2E63),
                                  size: 20,
                                ),

                                SizedBox(width: 8),

                                Text(
                                  "Perkiraan Cuaca Jawa Timur",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const Text(
                              "Lihat semua",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          height: 210,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _weatherCard("Jombang"),

                              const SizedBox(width: 14),

                              _weatherCard("Bojonegoro"),

                              const SizedBox(width: 14),

                              _weatherCard("Tuban"),

                              const SizedBox(width: 14),

                              _weatherCard("Lamongan"),
                            ],
                          ),
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
    );
  }

  Widget _bannerImage(String path) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(path, fit: BoxFit.cover),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String icon;

  const _StatCard(this.value, this.label, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(icon, width: 24),

          const SizedBox(height: 12),

          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 4),

          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}

Widget _chip(String text, bool active) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: active ? const Color(0xFFFF2E63) : Colors.white,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: active ? const Color(0xFFFF2E63) : Colors.grey.shade300,
      ),
    ),
    child: Text(
      text,
      style: TextStyle(
        color: active ? Colors.white : Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}

Widget _serviceItem(String image, String title) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE8E8E8)),
    ),
    child: Row(
      children: [
        Image.asset(image, width: 40, height: 40),

        const SizedBox(width: 14),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
}

class _CategoryCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const _CategoryCard({
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        children: [
          Image.asset(image, height: 70),

          const SizedBox(height: 14),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 6),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

Widget _agendaCard({required String title, required String location}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE8E8E8)),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.calendar_today, size: 15, color: Colors.green),

                  SizedBox(width: 6),

                  Text(
                    "Sabtu, 16 Mei 2026",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),

                  const SizedBox(width: 4),

                  Text(location, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 14),

        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: const Color(0xFFDDF0FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset("assets/images/logo_majadigi.png"),
          ),
        ),
      ],
    ),
  );
}

Widget _newsCard(String image, String title, String url) {
  return GestureDetector(
    onTap: () async {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    },

    child: Container(
      width: 340,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),

            child: Image.asset(
              image,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: const [
                    Icon(Icons.calendar_today, size: 15, color: Colors.green),

                    SizedBox(width: 6),

                    Text(
                      "Sabtu, 16 Mei 2026",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _weatherCard(String city) {
  return Container(
    width: 180,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE8E8E8)),
    ),
    child: Column(
      children: [
        Text(
          city,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 24),

        const Icon(Icons.cloud_outlined, size: 80, color: Color(0xFF7AA6D9)),

        const SizedBox(height: 20),

        const Text(
          "Berawan",
          style: TextStyle(color: Colors.grey, fontSize: 18),
        ),
      ],
    ),
  );
}
