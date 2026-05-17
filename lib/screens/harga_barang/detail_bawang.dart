import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DetailBawangScreen extends StatelessWidget {
  const DetailBawangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0047B3),

      body: Stack(
        children: [
          // 🔵 HEADER
          Container(
            height: 170,
            width: double.infinity,
            color: const Color(0xFF0047B3),
          ),

          SafeArea(
            child: Column(
              children: [
                // APPBAR
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),

                      const Expanded(
                        child: Center(
                          child: Text(
                            "Bawang Merah / kg",
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
                        // DROPDOWN
                        // =========================
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),

                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.grey,
                              ),

                              const SizedBox(width: 10),

                              const Expanded(
                                child: Text(
                                  "Malang",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        Color(0xFF121938),
                                  ),
                                ),
                              ),

                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey.shade600,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // =========================
                        // FILTER
                        // =========================
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),

                          child: Row(
                            children: [
                              _filterButton(
                                "7 Hari",
                                true,
                              ),

                              _filterButton(
                                "1 Bulan",
                                false,
                              ),

                              _filterButton(
                                "3 Bulan",
                                false,
                              ),

                              _filterButton(
                                "1 Tahun",
                                false,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // =========================
                        // PRICE
                        // =========================
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  const Text(
                                    "Rp36.418",
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontWeight:
                                          FontWeight.bold,
                                      color:
                                          Color(0xFF121938),
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Row(
                                    children: [
                                      const Text(
                                        "20% ↓",
                                        style: TextStyle(
                                          color:
                                              Colors.green,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          fontSize: 18,
                                        ),
                                      ),

                                      const SizedBox(
                                          width: 10),

                                      Text(
                                        "7 Hari terakhir",
                                        style: TextStyle(
                                          color: Colors
                                              .grey
                                              .shade700,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Image.asset(
                              "assets/images/bawang_merah.png",
                              width: 85,
                              height: 85,
                            ),
                          ],
                        ),

                        const SizedBox(height: 34),

                        // =========================
                        // GRAFIK
                        // =========================
                        const Text(
                          "Grafik Harga",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF121938),
                          ),
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          height: 260,
                          child: LineChart(
                            LineChartData(
                              minY: 25,
                              maxY: 50,

                              titlesData: FlTitlesData(
                                topTitles:
                                    const AxisTitles(
                                  sideTitles:
                                      SideTitles(
                                    showTitles: false,
                                  ),
                                ),

                                rightTitles:
                                    const AxisTitles(
                                  sideTitles:
                                      SideTitles(
                                    showTitles: false,
                                  ),
                                ),

                                leftTitles: AxisTitles(
                                  sideTitles:
                                      SideTitles(
                                    showTitles: true,
                                    interval: 5,
                                    reservedSize: 50,

                                    getTitlesWidget:
                                        (value, meta) {
                                      return Text(
                                        "${value.toInt()}.000",
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.grey,
                                          fontSize: 12,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                bottomTitles:
                                    AxisTitles(
                                  sideTitles:
                                      SideTitles(
                                    showTitles: true,

                                    getTitlesWidget:
                                        (value, meta) {
                                      List<String>
                                          dates = [
                                        "12/3",
                                        "17/3",
                                        "22/3",
                                        "27/3",
                                        "1/4",
                                        "6/4",
                                      ];

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(
                                          top: 10,
                                        ),
                                        child: Text(
                                          dates[value
                                              .toInt()],
                                          style:
                                              const TextStyle(
                                            color:
                                                Colors
                                                    .grey,
                                            fontSize:
                                                12,
                                          ),
                                        ),
                                      );
                                    },

                                    interval: 1,
                                  ),
                                ),
                              ),

                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 5,
                                getDrawingHorizontalLine:
                                    (value) {
                                  return FlLine(
                                    color: Colors
                                        .grey.shade300,
                                    dashArray: [4, 4],
                                  );
                                },
                              ),

                              borderData: FlBorderData(
                                show: false,
                              ),

                              lineBarsData: [
                                LineChartBarData(
                                  spots: const [
                                    FlSpot(0, 45),
                                    FlSpot(1, 40),
                                    FlSpot(2, 40),
                                    FlSpot(3, 35),
                                    FlSpot(4, 35),
                                    FlSpot(5, 30),
                                  ],

                                  isCurved: false,

                                  color: Colors.green,

                                  barWidth: 2,

                                  dotData:
                                      const FlDotData(
                                    show: false,
                                  ),

                                  belowBarData:
                                      BarAreaData(
                                    show: true,
                                    color: Colors.green
                                        .withOpacity(
                                            0.08),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // =========================
                        // STATISTIK
                        // =========================
                        const Text(
                          "Statistik",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF121938),
                          ),
                        ),

                        const SizedBox(height: 20),

                        _statItem(
                          "Harga ",
                          "Tertinggi",
                          Colors.pink,
                          "Rp45.000",
                        ),

                        _divider(),

                        _statItem(
                          "Harga ",
                          "Terendah",
                          Colors.green,
                          "Rp60.000",
                        ),

                        _divider(),

                        _statItem(
                          "Harga ",
                          "Rata-rata",
                          Colors.blue,
                          "Rp30.500",
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

  Widget _filterButton(
      String title, bool active) {
    return Expanded(
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFFDCE9FF)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: active
                  ? const Color(0xFF0E63FF)
                  : Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _statItem(
    String title,
    String highlight,
    Color color,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
                TextSpan(
                  text: highlight,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF121938),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: Colors.grey.shade300,
      height: 1,
    );
  }
}