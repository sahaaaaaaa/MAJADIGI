import 'package:flutter/material.dart';
import '../destinasi_wisata/destinasi_wisata_screen.dart';
import '../../widgets/layanan_item.dart';
import '../harga_barang/harga_bahan_pokok_screen.dart';
import '../nomor darurat/nomor_darurat.dart';
class LayananLainScreen extends StatefulWidget {
  const LayananLainScreen({super.key});

  @override
  State<LayananLainScreen> createState() => _LayananLainScreenState();
}

class _LayananLainScreenState extends State<LayananLainScreen> {
  bool pariwisataOpen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          // 🔵 HEADER (TETAP)
          Container(
            height: 140,
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
            decoration: const BoxDecoration(color: Color(0xFF0D57E7)),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Layanan Lain",
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

          // 🔹 CONTENT
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
                    "Featured",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  _gridFeatured(),

                  const SizedBox(height: 20),
                  const Divider(),

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

  // 🔥 FEATURED (PAKAI WIDGET)
  Widget _gridFeatured() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        LayananItem(
          title: "Klinik Hoaks",
          image: "assets/images/klinik_hoax.png",
          onTap: () {},
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
          onTap: () {},
        ),
        LayananItem(
          title: "Harga",
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
          onTap: () {},
        ),
        LayananItem(
          title: "Transjatim",
          image: "assets/images/transjatim_ajaib.png",
          onTap: () {},
        ),
        LayananItem(
          title: "RSSA",
          image: "assets/images/rsud_saifulanwar.png",
          onTap: () {},
        ),
        LayananItem(
          title: "Nomor Darurat",
          image: "assets/images/klinik_hoax.png",
          onTap: () {
            Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          const NomorDaruratScreen(),
    ),
  );
          },
        ),
        LayananItem(
          title: "Point Jatim",
          image: "assets/images/point_jatim.png",
          onTap: () {},
        ),
        LayananItem(
          title: "Islamic Center",
          image: "assets/images/islamic_center.png",
          onTap: () {},
        ),
      ],
    );
  }

  // 🔥 PARIWISATA (PAKAI WIDGET)
  Widget _gridPariwisata() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        LayananItem(
          title: "Nganjuk Smart City",
          image: "assets/images/nganjuk_smartcity.png",
          onTap: () {},
        ),
        LayananItem(
          title: "Pusaka Jatim",
          image: "assets/images/klinik_hoax.png",
          onTap: () {},
        ),
        LayananItem(
          title: "Paket Kunjungan",
          image: "assets/images/klinik_hoax.png",
          onTap: () {},
        ),
        LayananItem(
          title: "Khas Jatim",
          image: "assets/images/khas_jatim.png",
          onTap: () {},
        ),
        LayananItem(
          title: "Cak Durasim",
          image: "assets/images/cak_durasim.png",
          onTap: () {},
        ),
        LayananItem(
          title: "Virtual Tour",
          image: "assets/images/klinik_hoax.png",
          onTap: () {},
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

  // 🔹 LIST (NO CHANGE)
  Widget _simpleItem(String title) {
    return Column(
      children: [
        ListTile(title: Text(title), trailing: const Icon(Icons.expand_more)),
        const Divider(),
      ],
    );
  }
}
