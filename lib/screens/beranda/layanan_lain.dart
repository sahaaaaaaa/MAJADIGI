import 'package:flutter/material.dart';
import 'package:majadigi/screens/islamic_center/islamic_center_home_screen.dart';
import 'package:majadigi/screens/klinik_hoax/klinik_hoax_home_screen.dart';
import 'package:majadigi/screens/point_jatim/point_jatim_home_screen.dart';
import '../destinasi_wisata/destinasi_wisata_screen.dart';
import '../../widgets/layanan_item.dart';
import '../service_model.dart';

class LayananLainScreen extends StatefulWidget {

  final String kategori;

  const LayananLainScreen({
    super.key,
    required this.kategori,
  });

  @override
  State<LayananLainScreen> createState() => _LayananLainScreenState();
}

class _LayananLainScreenState extends State<LayananLainScreen> {
  bool pariwisataOpen = true;

  List<Recommendation>
      get _filteredLayanan {

    return recommendations
        .where(
          (item) =>
              item.kategori ==
              widget.kategori,
        )
        .toList();
  }

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
            decoration: const BoxDecoration(
              color: Color(0xFF0D57E7),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      widget.kategori,
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

                  GridView.builder(
                    shrinkWrap: true,

                    physics:
                        const NeverScrollableScrollPhysics(),

                    itemCount: _filteredLayanan.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1,
                    ),

                    itemBuilder: (context, index) {

                      final item =
                          _filteredLayanan[index];

                      return GestureDetector(
                        onTap: () {

                          if (item.screen != null) {

                            Navigator.push(
                              context,

                              MaterialPageRoute(
                                builder: (_) =>
                                    item.screen!,
                              ),
                            );
                          } else {

                            ScaffoldMessenger.of(
                                    context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Halaman belum tersedia",
                                ),
                              ),
                            );
                          }
                        },

                        child: Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(18),

                          border: Border.all(
                            color: const Color(
                              0xffEAEAEA,
                            ),
                          ),
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Container(
                              width: 52,
                              height: 52,

                              padding:
                                  const EdgeInsets.all(8),

                              decoration: BoxDecoration(
                                color: const Color(
                                  0xffF5F7FF,
                                ),

                                shape: BoxShape.circle,
                              ),

                              child: Image.asset(
                                "assets/images/${item.logo}",
                              ),
                            ),

                            const SizedBox(height: 14),

                            Text(
                              item.title,

                              maxLines: 2,

                              overflow:
                                  TextOverflow.ellipsis,

                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              item.description,

                              maxLines: 2,

                              overflow:
                                  TextOverflow.ellipsis,

                              style: TextStyle(
                                fontSize: 13,

                                color:
                                    Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        ),
                      );
                    },
                  ),
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const KlinikHoaksHomeScreen()),
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
                  builder: (_) => const DestinasiWisataScreen()),
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
          onTap: () {},
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
          onTap: () {},
        ),
        LayananItem(
          title: "Point Jatim",
          image: "assets/images/point_jatim.png",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PointJatimHomeScreen()),
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
                  builder: (_) => const IslamicCenterHomeScreen()),
            );
          },
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
              MaterialPageRoute(
                  builder: (_) => const DestinasiWisataScreen()),
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
        ListTile(
          title: Text(title),
          trailing: const Icon(Icons.expand_more),
        ),
        const Divider(),
      ],
    );
  }
}