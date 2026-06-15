import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:majadigi/features/harga_barang/data/harga_pokok_service.dart';
import 'package:majadigi/features/harga_barang/presentation/detail_bawang.dart';

class DetailHargaMalangScreen extends StatelessWidget {
  const DetailHargaMalangScreen({super.key, this.items = const []});

  final List<HargaPokokItem> items;

  static final NumberFormat _rupiahFormat = NumberFormat.decimalPattern(
    'id_ID',
  );

  @override
  Widget build(BuildContext context) {
    final averageGrowth = _averageGrowthText;
    final averageGrowthColor = _averageGrowthColor;
    final commodityUpCount = items.where((item) => item.isUp).length;
    final commodityDownCount = items.where((item) => item.isDown).length;
    final commodityItems = items.take(8).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0047B3),

      body: Stack(
        children: [
          // 🔵 HEADER
          Container(
            height: 170,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/latar_belakang.png"),
                fit: BoxFit.cover,
              ),
            ),
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
                                  averageGrowth,
                                  averageGrowthColor,
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
                                  commodityUpCount.toString(),
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
                                  commodityDownCount.toString(),
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

                        ...commodityItems.map(
                          (item) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailBawangScreen(item: item),
                                ),
                              );
                            },
                            child: _commodityItem(item: item),
                          ),
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

  Widget _commodityItem({required HargaPokokItem item}) {
    final up = item.isUp;
    final down = item.isDown;
    final trendColor = down
        ? Colors.green
        : up
        ? Colors.pink
        : Colors.grey;
    final trendIcon = down
        ? Icons.arrow_downward
        : up
        ? Icons.arrow_upward
        : Icons.remove;

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
          _commodityImage(item, width: 45, height: 45),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey, fontSize: 15),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Text(
                      _formatRupiah(item.price),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF121938),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Text(
                      _formatPercent(item.diffPercent),
                      style: TextStyle(
                        color: trendColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Icon(trendIcon, color: trendColor, size: 18),
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
                    spots: down
                        ? [
                            const FlSpot(0, 4),
                            const FlSpot(1, 3),
                            const FlSpot(2, 3),
                            const FlSpot(3, 2),
                            const FlSpot(4, 2),
                            const FlSpot(5, 1),
                          ]
                        : up
                        ? [
                            const FlSpot(0, 1),
                            const FlSpot(1, 2),
                            const FlSpot(2, 2),
                            const FlSpot(3, 3),
                            const FlSpot(4, 3),
                            const FlSpot(5, 4),
                          ]
                        : [
                            const FlSpot(0, 3),
                            const FlSpot(1, 3),
                            const FlSpot(2, 3),
                            const FlSpot(3, 3),
                            const FlSpot(4, 3),
                            const FlSpot(5, 3),
                          ],

                    isCurved: true,

                    color: trendColor,

                    barWidth: 2.5,

                    dotData: const FlDotData(show: false),

                    belowBarData: BarAreaData(
                      show: true,
                      color: trendColor.withOpacity(0.10),
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

  String get _averageGrowthText {
    if (items.isEmpty) {
      return "0%";
    }

    final total = items.fold<double>(
      0,
      (sum, item) => sum + item.diffPercentValue,
    );
    final average = total / items.length;
    final trend = average > 0
        ? "↑"
        : average < 0
        ? "↓"
        : "";

    return "${_formatGrowth(average.abs())}% $trend".trim();
  }

  Color get _averageGrowthColor {
    if (items.isEmpty) {
      return Colors.grey;
    }

    final total = items.fold<double>(
      0,
      (sum, item) => sum + item.diffPercentValue,
    );
    final average = total / items.length;

    if (average == 0) {
      return Colors.grey;
    }

    return average > 0 ? Colors.pink : Colors.green;
  }

  Widget _commodityImage(
    HargaPokokItem item, {
    required double width,
    double? height,
  }) {
    final fallback = _fallbackImageForName(item.name);

    if (item.imageUrl.startsWith('http')) {
      return Image.network(
        item.imageUrl,
        width: width,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return Image.asset(
            fallback,
            width: width,
            height: height,
            fit: BoxFit.contain,
          );
        },
      );
    }

    return Image.asset(
      item.imageUrl.isEmpty ? fallback : item.imageUrl,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }

  String _fallbackImageForName(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('bawang merah')) {
      return 'assets/images/bawang_merah.png';
    }
    if (lowerName.contains('bawang putih')) {
      return 'assets/images/bawang_putih.png';
    }
    if (lowerName.contains('beras')) {
      return 'assets/images/beras.png';
    }
    if (lowerName.contains('besi')) {
      return 'assets/images/besi.png';
    }
    if (lowerName.contains('buncis')) {
      return 'assets/images/buncis.png';
    }
    if (lowerName.contains('cabe') || lowerName.contains('cabai')) {
      return 'assets/images/cabe.png';
    }
    if (lowerName.contains('daging') || lowerName.contains('telur')) {
      return 'assets/images/daging.png';
    }
    if (lowerName.contains('ikan')) {
      return 'assets/images/ikan.png';
    }
    if (lowerName.contains('kol') || lowerName.contains('kubis')) {
      return 'assets/images/kol.png';
    }

    return 'assets/images/beras.png';
  }

  String _formatRupiah(int value) {
    return 'Rp${_rupiahFormat.format(value)}';
  }

  String _formatPercent(String value) {
    final normalized = value.replaceAll('-', '').replaceAll(' ', '').trim();
    return normalized.isEmpty ? '0%' : normalized;
  }

  String _formatGrowth(double value) {
    if (value >= 10) {
      return value.toStringAsFixed(0);
    }
    if (value >= 1) {
      return value.toStringAsFixed(2);
    }
    return value.toStringAsFixed(2);
  }
}
