import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'detail_bawang.dart';

class DetailHargaMalangScreen extends StatelessWidget {
  const DetailHargaMalangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0047B3),

      body: Stack(
        children: [
          // 🔵 HEADER
          Container(
            height: 170,
            decoration: const BoxDecoration(color: Color(0xFF0047B3)),
          ),

          SafeArea(
            child: Column(
              children: [
                // APPBAR
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
                            "Detail Harga - Malang",
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

                const SizedBox(height: 16),

                // CONTENT
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
                        // =========================
                        // RINGKASAN
                        // =========================
                        const Text(
                          "Ringkasan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF121938),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _summaryItem(
                                  "Rata-rata\nPertumbuhan",
                                  "10% ↑",
                                  Colors.pink,
                                ),
                              ),

                              Container(
                                width: 1,
                                height: 100,
                                color: Colors.grey.shade300,
                              ),

                              Expanded(
                                child: _summaryItem(
                                  "Komoditas\nNaik",
                                  "12",
                                  Colors.pink,
                                ),
                              ),

                              Container(
                                width: 1,
                                height: 100,
                                color: Colors.grey.shade300,
                              ),

                              Expanded(
                                child: _summaryItem(
                                  "Komoditas\nTurun",
                                  "8",
                                  Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // =========================
                        // HARGA KOMODITAS
                        // =========================
                        const Text(
                          "Harga Komoditas Utama",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF121938),
                          ),
                        ),

                        const SizedBox(height: 18),

                        _commodityItem(
                          image: "assets/images/bawang_putih.png",
                          title: "Bawang Putih / kg",
                          percent: "15%",
                          up: true,
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const DetailBawangScreen(),
                              ),
                            );
                          },
                          child: _commodityItem(
                            image: "assets/images/bawang_merah.png",
                            title: "Bawang Merah / kg",
                            percent: "20%",
                            up: false,
                          ),
                        ),

                        _commodityItem(
                          image: "assets/images/beras.png",
                          title: "Beras Medium / kg",
                          percent: "20%",
                          up: false,
                        ),

                        _commodityItem(
                          image: "assets/images/besi.png",
                          title: "Besi Beton 10 mm (12/...",
                          percent: "15%",
                          up: true,
                        ),

                        _commodityItem(
                          image: "assets/images/buncis.png",
                          title: "Buncis / kg",
                          percent: "20%",
                          up: false,
                        ),

                        const SizedBox(height: 16),

                        Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: const Center(
                            child: Text(
                              "Lihat Daftar Lengkap",
                              style: TextStyle(
                                color: Color(0xFF121938),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
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

  Widget _summaryItem(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Color(0xFF121938)),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _commodityItem({
    required String image,
    required String title,
    required String percent,
    required bool up,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Image.asset(image, width: 45, height: 45),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Text(
                      "Rp36.418",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF121938),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Text(
                      percent,
                      style: TextStyle(
                        color: up ? Colors.pink : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Icon(
                      up ? Icons.arrow_upward : Icons.arrow_downward,
                      color: up ? Colors.pink : Colors.green,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(
            width: 70,
            height: 40,
            child: LineChart(
              LineChartData(
                titlesData: const FlTitlesData(show: false),

                borderData: FlBorderData(show: false),

                gridData: const FlGridData(show: false),

                lineBarsData: [
                  LineChartBarData(
                    spots: up
                        ? [
                            const FlSpot(0, 1),
                            const FlSpot(1, 2),
                            const FlSpot(2, 2),
                            const FlSpot(3, 3),
                            const FlSpot(4, 3),
                            const FlSpot(5, 4),
                          ]
                        : [
                            const FlSpot(0, 4),
                            const FlSpot(1, 3),
                            const FlSpot(2, 3),
                            const FlSpot(3, 2),
                            const FlSpot(4, 2),
                            const FlSpot(5, 1),
                          ],

                    isCurved: true,

                    color: up ? Colors.pink : Colors.green,

                    barWidth: 2.5,

                    dotData: const FlDotData(show: false),

                    belowBarData: BarAreaData(
                      show: true,
                      color: (up ? Colors.pink : Colors.green).withOpacity(
                        0.10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
