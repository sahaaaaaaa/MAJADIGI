import 'package:flutter/material.dart';

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
          // 🔵 HEADER
          Container(
            height: 140,
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF0D57E7),
            ),
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
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                children: [
                  // 🔸 FEATURED
                  const Text(
                    "Featured",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 16),

                  _gridFeatured(),

                  const SizedBox(height: 20),
                  const Divider(),

                  // 🔸 PARIWISATA
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
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Icon(pariwisataOpen
                            ? Icons.expand_less
                            : Icons.expand_more),
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

  // 🔹 GRID FEATURED
  Widget _gridFeatured() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _Item("Klinik Hoaks", "assets/images/klinik_hoax.png"),
        _Item("Destinasi Wisata", "assets/images/destinasi_wisata.png"),
        _Item("Open Data", "assets/images/open_data.png"),
        _Item("Harga", "assets/images/khas_jatim.png"),
        _Item("RSUD Haji", "assets/images/rsud_haji.png"),
        _Item("Transjatim", "assets/images/transjatim_ajaib.png"),
        _Item("RSSA", "assets/images/rsud_saifulanwar.png"),
        _Item("Nomor Darurat", "assets/images/klinik_hoax.png"),
        _Item("Point Jatim", "assets/images/point_jatim.png"),
        _Item("Islamic Center", "assets/images/islamic_center.png"),
      ],
    );
  }

  // 🔹 GRID PARIWISATA
  Widget _gridPariwisata() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _Item("Nganjuk Smart City", "assets/images/nganjuk_smartcity.png"),
        _Item("Pusaka Jatim", "assets/images/klinik_hoax.png"),
        _Item("Paket Kunjungan", "assets/images/klinik_hoax.png"),
        _Item("Khas Jatim", "assets/images/khas_jatim.png"),
        _Item("Cak Durasim", "assets/images/cak_durasim.png"),
        _Item("Virtual Tour", "assets/images/klinik_hoax.png"),
        _Item("Destinasi Wisata", "assets/images/destinasi_wisata.png"),
      ],
    );
  }

  // 🔹 SIMPLE LIST
  Widget _simpleItem(String title) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: const Icon(Icons.expand_more),
        ),
        const Divider(),
      ],
    );
  }
}

// 🔹 GRID ITEM
class _Item extends StatelessWidget {
  final String title;
  final String image;

  const _Item(this.title, this.image);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(image, width: 50, height: 50),
        const SizedBox(height: 6),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }
}