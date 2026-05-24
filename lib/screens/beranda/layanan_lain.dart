import 'package:flutter/material.dart';

import '../../services/layanan_service.dart';
import '../../widgets/layanan_item.dart';
import 'home_service_item.dart';
import 'package:majadigi/screens/islamic_center/islamic_center_home_screen.dart';
import 'package:majadigi/screens/klinik_hoax/klinik_hoax_home_screen.dart';
import 'package:majadigi/screens/open_data/open_data_screen.dart';
import 'package:majadigi/screens/point_jatim/point_jatim_home_screen.dart';

import '../destinasi_wisata/destinasi_wisata_screen.dart';
import '../harga_barang/harga_bahan_pokok_screen.dart';
import '../nomor darurat/nomor_darurat.dart';
import '../rsud_provjatim/rsud_jatim.dart';
import '../rssa/rssa_screen.dart';
import '../transjatim/transjatim_screen.dart';

class LayananLainScreen extends StatefulWidget {
  const LayananLainScreen({super.key, this.services});

  final List<HomeServiceItem>? services;

  @override
  State<LayananLainScreen> createState() => _LayananLainScreenState();
}

class _LayananLainScreenState extends State<LayananLainScreen> {
  final LayananService _layananService = LayananService();
  bool _isLoading = false;
  bool pariwisataOpen = false;
  List<HomeServiceItem> _services = [];

  @override
  void initState() {
    super.initState();

    final services = widget.services;
    if (services != null) {
      _services = services;
      return;
    }

    _loadServices();
  }

  @override
  void dispose() {
    _layananService.dispose();
    super.dispose();
  }

  Future<void> _loadServices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final layanan = await _layananService.getInstalledLayanan();
      if (!mounted) {
        return;
      }
      setState(() {
        _services = layanan
            .map(homeServiceFromLayanan)
            .whereType<HomeServiceItem>()
            .toList();
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ================= POPUP =================
  void _showLayananPopup({
    required String title,
    required String image,
    required String desc,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      backgroundColor: Colors.transparent,

      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),

          decoration: const BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Container(
                width: 60,
                height: 5,

                decoration: BoxDecoration(
                  color: Colors.grey.shade300,

                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              const SizedBox(height: 30),

              Image.asset(image, height: 90),

              const SizedBox(height: 24),

              Text(
                title,
                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0B1B53),
                ),
              ),

              const SizedBox(height: 14),

              Text(
                desc,
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 54,

                      decoration: BoxDecoration(
                        color: const Color(0xFFE9EEF9),

                        borderRadius: BorderRadius.circular(40),
                      ),

                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        child: const Text(
                          "Detail Layanan",

                          style: TextStyle(
                            color: Color(0xFF0E63FF),

                            fontWeight: FontWeight.w600,

                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Container(
                      height: 54,

                      decoration: BoxDecoration(
                        color: const Color(0xFF0E63FF),

                        borderRadius: BorderRadius.circular(40),
                      ),

                      child: TextButton(
                        onPressed: () {},

                        child: const Text(
                          "Install",

                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,

                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      body: Column(
        children: [
          // ================= HEADER =================
          Container(
            height: 140,

            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),

            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/latar_belakang.png"),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),

                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                const Expanded(
                  child: Center(
                    child: Text(
                      "Layanan Lain",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 40),
              ],
            ),
          ),

          // ================= CONTENT =================
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),

              decoration: const BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),

              child: ListView(
                children: [
                  const Text(
                    'Semua layanan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  _gridFeatured(),

                  const SizedBox(height: 20),

                  const Divider(),

                  // ================= PARIWISATA =================
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        pariwisataOpen = !pariwisataOpen;
                      });
                    },

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        const Text(
                          "Pariwisata & Kebudayaan",

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Icon(
                          pariwisataOpen
                              ? Icons.expand_less
                              : Icons.expand_more,
                        ),
                      ],
                    ),
                  ),

                  if (pariwisataOpen) ...[
                    const SizedBox(height: 16),

                    _gridPariwisata(),
                  ],

                  const Divider(),

                  _simpleItem("Pendidikan"),
                  _simpleItem("Ketenagakerjaan"),
                  _simpleItem("Ekonomi & Bisnis"),
                  _simpleItem("Kesehatan"),
                  _simpleItem("Kependudukan"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= FEATURED =================
  Widget _gridFeatured() {
    return GridView.count(
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

              MaterialPageRoute(builder: (_) => const KlinikHoaksHomeScreen()),
            );
          },
        ),

        LayananItem(
          title: "Destinasi Wisata",
          image: "assets/images/destinasi_wisata.png",

          onTap: () {
            Navigator.push(
              context,

              MaterialPageRoute(builder: (_) => const DestinasiWisataScreen()),
            );
          },
        ),

        LayananItem(
          title: "Open Data",
          image: "assets/images/open_data.png",

          onTap: () {
            Navigator.push(
              context,

              MaterialPageRoute(builder: (_) => const OpenDataScreen()),
            );
          },
        ),

        LayananItem(
          title: "Harga Bahan",
          image: "assets/images/khas_jatim.png",

          onTap: () {
            Navigator.push(
              context,

              MaterialPageRoute(builder: (_) => const HargaBahanPokokScreen()),
            );
          },
        ),

        LayananItem(
          title: "RSUD Haji",
          image: "assets/images/rsud_haji.png",

          onTap: () {
            Navigator.push(
              context,

              MaterialPageRoute(builder: (_) => const RsudHajiScreen()),
            );
          },
        ),

        LayananItem(
          title: "Transjatim",
          image: "assets/images/transjatim_ajaib.png",

          onTap: () {
            Navigator.push(
              context,

              MaterialPageRoute(builder: (_) => const TransjatimScreen()),
            );
          },
        ),

        LayananItem(
          title: "RSSA",
          image: "assets/images/rsud_saifulanwar.png",

          onTap: () {
            Navigator.push(
              context,

              MaterialPageRoute(builder: (_) => const RssaScreen()),
            );
          },
        ),

        LayananItem(
          title: "Nomor Darurat",
          image: "assets/images/klinik_hoax.png",

          onTap: () {
            Navigator.push(
              context,

              MaterialPageRoute(builder: (_) => const NomorDaruratScreen()),
            );
          },
        ),

        LayananItem(
          title: "Point Jatim",
          image: "assets/images/point_jatim.png",

          onTap: () {
            Navigator.push(
              context,

              MaterialPageRoute(builder: (_) => const PointJatimHomeScreen()),
            );
          },
        ),

        LayananItem(
          title: "Islamic Center",
          image: "assets/images/islamic_center.png",

          onTap: () {
            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) => const IslamicCenterHomeScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  // ================= PARIWISATA =================
  Widget _gridPariwisata() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,

      physics: const NeverScrollableScrollPhysics(),

      children: [
        LayananItem(
          title: "Nganjuk Smart City",
          image: "assets/images/nganjuk_smartcity.png",

          onTap: () {
            _showLayananPopup(
              title: "Nganjuk Smart City",

              image: "assets/images/nganjuk_smartcity.png",

              desc:
                  "Aplikasi Nganjuk Smart City portal layanan digital Kabupaten Nganjuk.",
            );
          },
        ),

        LayananItem(
          title: "Pusaka Jatim",
          image: "assets/images/klinik_hoax.png",

          onTap: () {
            _showLayananPopup(
              title: "Pusaka Jatim",

              image: "assets/images/klinik_hoax.png",

              desc: "Platform informasi budaya dan warisan Jawa Timur.",
            );
          },
        ),

        LayananItem(
          title: "Paket Kunjungan",
          image: "assets/images/logo_majadigi.png",

          onTap: () {
            _showLayananPopup(
              title: "Paket Kunjungan Agrowisata",

              image: "assets/images/logo_majadigi.png",

              desc:
                  "Layanan wisata agro Jawa Timur untuk edukasi dan kunjungan perkebunan.",
            );
          },
        ),

        LayananItem(
          title: "Khas Jatim",
          image: "assets/images/khas_jatim.png",

          onTap: () {
            _showLayananPopup(
              title: "Khas Jatim",

              image: "assets/images/khas_jatim.png",

              desc:
                  "Layanan informasi produk unggulan dan UMKM khas Jawa Timur.",
            );
          },
        ),

        LayananItem(
          title: "Cak Durasim",
          image: "assets/images/cak_durasim.png",

          onTap: () {
            _showLayananPopup(
              title: "Cak Durasim",

              image: "assets/images/cak_durasim.png",

              desc: "Pusat pertunjukan seni dan budaya Jawa Timur.",
            );
          },
        ),

        LayananItem(
          title: "Virtual Tour",
          image: "assets/images/klinik_hoax.png",

          onTap: () {
            _showLayananPopup(
              title: "Virtual Tour",

              image: "assets/images/klinik_hoax.png",

              desc: "Tur virtual wisata dan budaya Jawa Timur secara online.",
            );
          },
        ),

        LayananItem(
          title: "Destinasi Wisata",
          image: "assets/images/destinasi_wisata.png",

          onTap: () {
            Navigator.push(
              context,

              MaterialPageRoute(builder: (_) => const DestinasiWisataScreen()),
            );
          },
        ),
      ],
    );
  }

  // ================= SIMPLE ITEM =================
  Widget _simpleItem(String title) {
    return Column(
      children: [
        ListTile(title: Text(title), trailing: const Icon(Icons.expand_more)),

        const Divider(),
      ],
    );
  }
}
