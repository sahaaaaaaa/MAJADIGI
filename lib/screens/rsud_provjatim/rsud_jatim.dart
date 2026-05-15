import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'informasi_rsud_jatim.dart';
class RsudHajiScreen extends StatefulWidget {
  const RsudHajiScreen({super.key});

  @override
  State<RsudHajiScreen> createState() => _RsudHajiScreenState();
}

class _RsudHajiScreenState extends State<RsudHajiScreen> {
  final PageController _pageController = PageController();
  int currentPage = 1;

  final List<String> images = [
    'assets/images/rsud1.png',
    'assets/images/rsud2.png',
    'assets/images/rsud3.png',
  ];

  final List<Map<String, dynamic>> ruangData = [
    {
      "warna": const Color(0xFF27AE60),
      "ruang": "HCU",
      "kapasitas": "10",
      "terisi": "10",
      "tersedia": "0",
    },
    {
      "warna": const Color(0xFF1565FF),
      "ruang": "ICCU/ICVCU Dengan Ventilator",
      "kapasitas": "10",
      "terisi": "10",
      "tersedia": "0",
    },
    {
      "warna": const Color(0xFFA142F4),
      "ruang": "ICCU/ICVCU Tanpa Ventilator",
      "kapasitas": "10",
      "terisi": "10",
      "tersedia": "0",
    },
    {
      "warna": const Color(0xFFF5A623),
      "ruang": "ICU Dengan Ventilator",
      "kapasitas": "10",
      "terisi": "10",
      "tersedia": "0",
    },
    {
      "warna": const Color(0xFF149CE6),
      "ruang": "ISOLASI",
      "kapasitas": "10",
      "terisi": "10",
      "tersedia": "0",
    },
    {
      "warna": const Color(0xFF1565FF),
      "ruang": "Intermediate Ward (IGD)",
      "kapasitas": "10",
      "terisi": "10",
      "tersedia": "0",
    },
    {
      "warna": const Color(0xFF149CE6),
      "ruang": "Isolasi Tekanan Negatif",
      "kapasitas": "10",
      "terisi": "10",
      "tersedia": "0",
    },
    {
      "warna": const Color(0xFF27AE60),
      "ruang": "KELAS I",
      "kapasitas": "10",
      "terisi": "10",
      "tersedia": "0",
    },
    {
      "warna": const Color(0xFFFF0054),
      "ruang": "KELAS IIKELAS II",
      "kapasitas": "10",
      "terisi": "10",
      "tersedia": "0",
    },
    {
      "warna": const Color(0xFF149CE6),
      "ruang": "KELAS III",
      "kapasitas": "10",
      "terisi": "10",
      "tersedia": "0",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Stack(
        children: [
          // 🔵 HEADER BACKGROUND
          Container(
            width: double.infinity,
            height: 320,
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

          SafeArea(
            child: Column(
              children: [
                // 🔹 HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),

                      const Expanded(
                        child: Text(
                          "RSUD Haji Prov. Jatim",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.bookmark_border,
                              color: Colors.white,
                            ),
                          ),

                          IconButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const InformasiRsudScreen(),
      ),
    );
  },
  icon: const Icon(
    Icons.info_outline,
    color: Colors.white,
  ),
),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // 🔥 SLIDER IMAGE
                        SizedBox(
                          height: 210,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: images.length,
                            onPageChanged: (index) {
                              setState(() {
                                currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(
                                    22,
                                  ),
                                  child: Image.asset(
                                    images[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 12),

                        // 🔥 INDICATOR
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: List.generate(
                            images.length,
                            (index) => Container(
                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal: 3,
                              ),
                              width:
                                  currentPage == index
                                      ? 30
                                      : 10,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(
                                  10,
                                ),
                                color:
                                    currentPage == index
                                        ? Colors.white
                                        : Colors.white54,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // 🔥 CONTENT
                        Container(
                          width: double.infinity,
                          decoration:
                              const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            borderRadius:
                                BorderRadius.vertical(
                              top: Radius.circular(34),
                            ),
                          ),

                          child: Padding(
                            padding:
                                const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                const SizedBox(height: 8),

                                const Text(
                                  "Ketersediaan Kamar Rawat",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.w700,
                                    color:
                                        Color(0xFF121938),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration:
                                      BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      8,
                                    ),
                                  ),
                                  child: const Text(
                                    "2026-04-06 11:55:55",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          Colors.grey,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                    height: 18),

                                // 🔥 CARD TOTAL
                                Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets
                                          .all(20),
                                  decoration:
                                      BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      20,
                                    ),
                                    border: Border.all(
                                      color:
                                          Colors.grey
                                              .shade300,
                                    ),
                                  ),

                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                    children: [
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Text(
                                            "306",
                                            style:
                                                TextStyle(
                                              fontSize:
                                                  40,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                              color: Color(
                                                0xFF121938,
                                              ),
                                            ),
                                          ),

                                          Text(
                                            "Total Kamar Rawat",
                                            style:
                                                TextStyle(
                                              fontSize:
                                                  15,
                                            ),
                                          ),
                                        ],
                                      ),

                                      SvgPicture.asset(
                                        'assets/images/icons/building-07.svg',
                                        width: 32,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(
                                    height: 14),

                                // 🔥 TERSEDIA TERISI
                                Row(
                                  children: [
                                    Expanded(
                                      child: _smallCard(
                                        value: "76",
                                        label:
                                            "Tersedia",
                                        icon:
                                            'assets/images/icons/users-check.svg',
                                        valueColor:
                                            const Color(
                                          0xFF27AE60,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                        width: 14),

                                    Expanded(
                                      child: _smallCard(
                                        value: "230",
                                        label:
                                            "Terisi",
                                        icon:
                                            'assets/images/icons/users-up-01.svg',
                                        valueColor:
                                            const Color(
                                          0xFFFF6B00,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                    height: 24),

                                const Text(
                                  "Status Ketersediaan Ruangan",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.w700,
                                    color:
                                        Color(0xFF121938),
                                  ),
                                ),

                                const SizedBox(
                                    height: 16),

                                // 🔥 BAR WARNA
                                Row(
                                  children: [
                                    _barColor(
                                        const Color(
                                            0xFF27AE60)),
                                    _barColor(
                                        const Color(
                                            0xFF1565FF)),
                                    _barColor(
                                        const Color(
                                            0xFFA142F4)),
                                    _barColor(
                                        const Color(
                                            0xFFF5A623)),
                                    _barColor(
                                        const Color(
                                            0xFF149CE6)),
                                    _barColor(
                                        const Color(
                                            0xFFFF0054)),
                                    _barColor(
                                        const Color(
                                            0xFF0050C8)),
                                  ],
                                ),

                                const SizedBox(
                                    height: 14),

                                // 🔥 TABLE
                                Container(
                                  decoration:
                                      BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      20,
                                    ),
                                    border: Border.all(
                                      color:
                                          Colors.grey
                                              .shade300,
                                    ),
                                  ),

                                  child:
                                      SingleChildScrollView(
                                    scrollDirection:
                                        Axis.horizontal,
                                    child: DataTable(
                                      headingRowHeight:
                                          50,
                                      columnSpacing:
                                          30,

                                      columns: const [
                                        DataColumn(
                                          label: Text(
                                            "Ruang",
                                          ),
                                        ),

                                        DataColumn(
                                          label: Text(
                                            "Kapasitas",
                                          ),
                                        ),

                                        DataColumn(
                                          label: Text(
                                            "Terisi",
                                          ),
                                        ),

                                        DataColumn(
                                          label: Text(
                                            "Tersedia",
                                          ),
                                        ),
                                      ],

                                      rows:
                                          ruangData.map(
                                        (item) {
                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                Row(
                                                  children: [
                                                    Container(
                                                      width:
                                                          10,
                                                      height:
                                                          10,
                                                      decoration:
                                                          BoxDecoration(
                                                        color:
                                                            item['warna'],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                          20,
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(
                                                        width:
                                                            12),

                                                    Text(
                                                      item[
                                                          'ruang'],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              DataCell(
                                                Text(item[
                                                    'kapasitas']),
                                              ),

                                              DataCell(
                                                Text(
                                                  item[
                                                      'terisi'],
                                                  style:
                                                      const TextStyle(
                                                    color:
                                                        Color(
                                                      0xFFFF6B00,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              DataCell(
                                                Text(
                                                  item[
                                                      'tersedia'],
                                                  style:
                                                      const TextStyle(
                                                    color:
                                                        Color(
                                                      0xFF27AE60,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                    height: 30),
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

  Widget _barColor(Color color) {
    return Expanded(
      child: Container(
        height: 16,
        color: color,
      ),
    );
  }

  Widget _smallCard({
    required String value,
    required String label,
    required String icon,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),

              SvgPicture.asset(
                icon,
                width: 22,
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF121938),
            ),
          ),
        ],
      ),
    );
  }
}