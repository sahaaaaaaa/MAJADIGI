import 'package:flutter/material.dart';

class SemuaLayananDaerahScreen extends StatefulWidget {
  const SemuaLayananDaerahScreen({super.key});

  @override
  State<SemuaLayananDaerahScreen> createState() =>
      _SemuaLayananDaerahScreenState();
}

class _SemuaLayananDaerahScreenState
    extends State<SemuaLayananDaerahScreen> {
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
  Widget build(BuildContext context) {
    final layanan = [
      {
        "title": "Paket Kunjungan Agrowisata",
        "image": "assets/images/logo_majadigi.png",
      },
      {
        "title": "Islamic Center",
        "image": "assets/images/islamic_center.png",
      },
      {
        "title": "BAPENDA Jawa Timur",
        "image": "assets/images/open_data.png",
      },
      {
        "title": "SAPA BANSOS",
        "image": "assets/images/logo_majadigi.png",
      },
      {
        "title": "RS Paru Manguharjo",
        "image": "assets/images/rsud_haji.png",
      },
      {
        "title": "RS Paru Jember",
        "image": "assets/images/rs_jember.png",
      },
      {
        "title": "Forum Konsultasi Disnak",
        "image": "assets/images/logo_majadigi.png",
      },
      {
        "title": "Rumah ASN",
        "image": "assets/images/rumah_asn.png",
      },
      {
        "title": "RSUD Haji Prov. Jatim",
        "image": "assets/images/rsud_haji.png",
      },
      {
        "title": "SIMPEL K3",
        "image": "assets/images/logo_majadigi.png",
      },
      {
        "title": "Beasiswa LPPD Jatim",
        "image": "assets/images/beasiswa.png",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: Stack(
        children: [
          // HEADER BACKGROUND
          Container(
            width: double.infinity,
            height: 170,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/latar_belakang.png",
                ),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),

                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },

                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),

                      const Expanded(
                        child: Text(
                          "Semua Layanan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 24),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // CONTENT
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),

                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),

                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),

                    child: ListView(
                      children: [
                        // DROPDOWN
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(30),

                            border: Border.all(
                              color: const Color(0xFF1D4F91),
                              width: 1.5,
                            ),
                          ),

                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedDaerah,
                              isExpanded: true,

                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                              ),

                              items: daerahList.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),

                              onChanged: (value) {
                                setState(() {
                                  selectedDaerah = value!;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // MAP
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(18),

                          child: Image.asset(
                            "assets/images/mapsjatim.png",
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // LIST LAYANAN
                        ...layanan.map(
                          (item) => Container(
                            margin: const EdgeInsets.only(
                              bottom: 12,
                            ),

                            padding: const EdgeInsets.all(16),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(16),

                              border: Border.all(
                                color: const Color(0xFFE8E8E8),
                              ),
                            ),

                            child: Row(
                              children: [
                                Image.asset(
                                  item["image"]!,
                                  width: 42,
                                  height: 42,
                                  fit: BoxFit.contain,
                                ),

                                const SizedBox(width: 14),

                                Expanded(
                                  child: Text(
                                    item["title"]!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),

                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
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
}