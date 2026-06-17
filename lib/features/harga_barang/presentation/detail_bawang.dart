import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import 'package:majadigi/features/harga_barang/data/harga_pokok_service.dart';

class DetailBawangScreen extends StatefulWidget {
  const DetailBawangScreen({super.key, this.item});

  final HargaPokokItem? item;

  @override
  State<DetailBawangScreen> createState() => _DetailBawangScreenState();
}

class _DetailBawangScreenState extends State<DetailBawangScreen> {
  final HargaPokokService _hargaPokokService = HargaPokokService();

  static final NumberFormat _rupiahFormat = NumberFormat.decimalPattern(
    'id_ID',
  );
  static final DateFormat _apiDateFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _chartDateFormat = DateFormat('d/M');
  static const List<String> _periodLabels = [
    '7 Hari',
    '1 Bulan',
    '3 Bulan',
    '1 Tahun',
  ];

  int _selectedPeriodIndex = 0;
  int _historyRequestSerial = 0;
  int? _selectedHistoryIndex;
  bool _isLoadingHistory = false;
  List<_HargaHistoryPoint> _historyPoints = [];

  HargaPokokItem get _selectedItem {
    return widget.item ??
        HargaPokokItem(
          id: 39,
          name: "Bawang Merah / kg",
          unit: "kg",
          diff: -20,
          diffPercent: "20%",
          icon: "down",
          imageUrl: "assets/images/bawang_merah.png",
          price: 36418,
          yesterdayPrice: 45000,
        );
  }

  String get _selectedPeriodLabel => _periodLabels[_selectedPeriodIndex];

  @override
  void initState() {
    super.initState();
    _historyPoints = _fallbackHistory(_selectedItem);
    _selectedHistoryIndex = _historyPoints.length - 1;
    _fetchHistory();
  }

  @override
  void dispose() {
    _hargaPokokService.dispose();
    super.dispose();
  }

  void _selectPeriod(int index) {
    if (_selectedPeriodIndex == index) {
      return;
    }

    setState(() {
      _selectedPeriodIndex = index;
      _historyPoints = _fallbackHistory(_selectedItem);
      _selectedHistoryIndex = _historyPoints.length - 1;
    });
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final selectedItem = _selectedItem;
    final requestSerial = ++_historyRequestSerial;
    final dates = _datesForSelectedPeriod(DateTime.now());

    setState(() {
      _isLoadingHistory = true;
    });

    final prices = await Future.wait(
      dates.map((date) => _fetchPriceForDate(selectedItem, date)),
    );

    if (!mounted || requestSerial != _historyRequestSerial) {
      return;
    }

    final fallback = _fallbackHistory(selectedItem);
    final points = List.generate(dates.length, (index) {
      return _HargaHistoryPoint(
        date: dates[index],
        price: prices[index] ?? fallback[index].price,
      );
    });

    setState(() {
      _historyPoints = points;
      _selectedHistoryIndex = points.length - 1;
      _isLoadingHistory = false;
    });
  }

  Future<int?> _fetchPriceForDate(HargaPokokItem item, DateTime date) async {
    try {
      final response = await _hargaPokokService.getPrices(
        page: 1,
        limit: 12,
        sort: 'name',
        date: _apiDateFormat.format(date),
        name: item.name,
      );

      final exactMatch = response.priceList.where((entry) {
        return entry.id == item.id ||
            _normalizeName(entry.name) == _normalizeName(item.name);
      }).toList();

      if (exactMatch.isNotEmpty) {
        return exactMatch.first.price;
      }

      if (response.priceList.isNotEmpty) {
        return response.priceList.first.price;
      }
    } catch (_) {}

    return null;
  }

  List<DateTime> _datesForSelectedPeriod(DateTime now) {
    final offsets = switch (_selectedPeriodIndex) {
      0 => const [6, 5, 4, 3, 2, 0],
      1 => const [30, 24, 18, 12, 6, 0],
      2 => const [90, 72, 54, 36, 18, 0],
      _ => const [365, 292, 219, 146, 73, 0],
    };

    return offsets
        .map((days) => DateTime(now.year, now.month, now.day - days))
        .toList();
  }

  List<_HargaHistoryPoint> _fallbackHistory(HargaPokokItem item) {
    final dates = _datesForSelectedPeriod(DateTime.now());
    final start = _previousPrice(item);
    final end = item.price;
    final step = dates.length <= 1 ? 0 : (end - start) / (dates.length - 1);

    return List.generate(dates.length, (index) {
      return _HargaHistoryPoint(
        date: dates[index],
        price: (start + (step * index)).round(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = _selectedItem;
    final chartSpots = _chartSpots;
    final chartMinY = _chartMinY;
    final chartMaxY = _chartMaxY;
    final selectedPoint = _selectedHistoryPoint;
    final highestPrice = _historyPrices.reduce(math.max);
    final lowestPrice = _historyPrices.reduce(math.min);
    final averagePrice =
        (_historyPrices.reduce((a, b) => a + b) / _historyPrices.length)
            .round();
    final growthPercent = _selectedGrowthPercent;
    final trendColor = growthPercent < 0
        ? Colors.green
        : growthPercent > 0
        ? Colors.pink
        : Colors.grey;
    final trendIcon = growthPercent < 0
        ? Icons.arrow_downward
        : growthPercent > 0
        ? Icons.arrow_upward
        : Icons.remove;

    return Scaffold(
      backgroundColor: const Color(0xFF0047B3),

      body: Stack(
        children: [
          // 🔵 HEADER
          Container(
            height: 170,
            width: double.infinity,
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

                      Expanded(
                        child: Center(
                          child: Text(
                            selectedItem.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
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
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 54,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
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
                                    color: Color(0xFF121938),
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
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.grey.shade300),
                          ),

                          child: Row(
                            children: List.generate(
                              _periodLabels.length,
                              (index) => _filterButton(
                                _periodLabels[index],
                                _selectedPeriodIndex == index,
                                () => _selectPeriod(index),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // =========================
                        // PRICE
                        // =========================
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _formatRupiah(selectedPoint.price),
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF121938),
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Row(
                                    children: [
                                      Text(
                                        "${_formatGrowth(growthPercent)} ",
                                        style: TextStyle(
                                          color: trendColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),

                                      Icon(
                                        trendIcon,
                                        color: trendColor,
                                        size: 18,
                                      ),

                                      const SizedBox(width: 10),

                                      Text(
                                        _selectedHistoryIndex ==
                                                _historyPoints.length - 1
                                            ? "$_selectedPeriodLabel terakhir"
                                            : _chartDateFormat.format(
                                                selectedPoint.date,
                                              ),
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            _commodityImage(
                              selectedItem,
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
                              lineTouchData: LineTouchData(
                                touchCallback:
                                    (
                                      FlTouchEvent event,
                                      LineTouchResponse? response,
                                    ) {
                                      final spots = response?.lineBarSpots;
                                      if (!event.isInterestedForInteractions ||
                                          spots == null ||
                                          spots.isEmpty) {
                                        return;
                                      }

                                      final index = spots.first.spotIndex;
                                      if (index < 0 ||
                                          index >= _historyPoints.length ||
                                          index == _selectedHistoryIndex) {
                                        return;
                                      }

                                      setState(() {
                                        _selectedHistoryIndex = index;
                                      });
                                    },
                                getTouchedSpotIndicator:
                                    (
                                      LineChartBarData barData,
                                      List<int> spotIndexes,
                                    ) {
                                      return spotIndexes.map((spotIndex) {
                                        return TouchedSpotIndicatorData(
                                          FlLine(
                                            color: trendColor.withOpacity(0.45),
                                            strokeWidth: 2,
                                          ),
                                          FlDotData(
                                            getDotPainter:
                                                (
                                                  spot,
                                                  percent,
                                                  barData,
                                                  index,
                                                ) {
                                                  return FlDotCirclePainter(
                                                    radius: 5,
                                                    color: Colors.white,
                                                    strokeWidth: 3,
                                                    strokeColor: trendColor,
                                                  );
                                                },
                                          ),
                                        );
                                      }).toList();
                                    },
                                touchTooltipData: LineTouchTooltipData(
                                  getTooltipColor: (_) =>
                                      const Color(0xFF121938),
                                  getTooltipItems:
                                      (List<LineBarSpot> touchedSpots) {
                                        return touchedSpots.map((spot) {
                                          final index = spot.spotIndex;
                                          if (index < 0 ||
                                              index >= _historyPoints.length) {
                                            return null;
                                          }

                                          final point = _historyPoints[index];
                                          return LineTooltipItem(
                                            '${_chartDateFormat.format(point.date)}\n',
                                            const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: _formatRupiah(
                                                  point.price,
                                                ),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList();
                                      },
                                ),
                              ),
                              minX: 0,
                              maxX: (_historyPoints.length - 1).toDouble(),
                              minY: chartMinY,
                              maxY: chartMaxY,

                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),

                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),

                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 5,
                                    reservedSize: 50,

                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        "${value.toInt()}.000",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,

                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();
                                      if (index < 0 ||
                                          index >= _historyPoints.length) {
                                        return const SizedBox.shrink();
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          _chartDateFormat.format(
                                            _historyPoints[index].date,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
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
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.grey.shade300,
                                    dashArray: [4, 4],
                                  );
                                },
                              ),

                              borderData: FlBorderData(show: false),

                              lineBarsData: [
                                LineChartBarData(
                                  spots: chartSpots,

                                  isCurved: false,

                                  color: trendColor,

                                  barWidth: 2,

                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) {
                                          final selected =
                                              index == _selectedHistoryIndex;
                                          return FlDotCirclePainter(
                                            radius: selected ? 5 : 0,
                                            color: Colors.white,
                                            strokeWidth: selected ? 3 : 0,
                                            strokeColor: trendColor,
                                          );
                                        },
                                  ),

                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: trendColor.withOpacity(0.08),
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
                          _formatRupiah(highestPrice),
                        ),

                        _divider(),

                        _statItem(
                          "Harga ",
                          "Terendah",
                          Colors.green,
                          _formatRupiah(lowestPrice),
                        ),

                        _divider(),

                        _statItem(
                          "Harga ",
                          "Rata-rata",
                          Colors.blue,
                          _formatRupiah(averagePrice),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (_isLoadingHistory) const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _filterButton(String title, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 38,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFDCE9FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: active ? const Color(0xFF0E63FF) : Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statItem(String title, String highlight, Color color, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(color: Colors.grey, fontSize: 18),
                ),
                TextSpan(
                  text: highlight,
                  style: TextStyle(color: color, fontSize: 18),
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
    return Divider(color: Colors.grey.shade300, height: 1);
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

  List<int> get _historyPrices {
    if (_historyPoints.isEmpty) {
      return [_selectedItem.price];
    }

    return _historyPoints.map((point) => point.price).toList();
  }

  int get _activeHistoryIndex {
    if (_historyPoints.isEmpty) {
      return 0;
    }

    final index = _selectedHistoryIndex ?? _historyPoints.length - 1;
    return index.clamp(0, _historyPoints.length - 1).toInt();
  }

  _HargaHistoryPoint get _selectedHistoryPoint {
    if (_historyPoints.isEmpty) {
      return _HargaHistoryPoint(
        date: DateTime.now(),
        price: _selectedItem.price,
      );
    }

    return _historyPoints[_activeHistoryIndex];
  }

  List<FlSpot> get _chartSpots {
    return List.generate(_historyPoints.length, (index) {
      return FlSpot(index.toDouble(), _historyPoints[index].price / 1000);
    });
  }

  double get _chartMinY {
    final minPrice = _historyPrices.reduce(math.min) / 1000;
    return math.max(0, minPrice - 5);
  }

  double get _chartMaxY {
    final maxPrice = _historyPrices.reduce(math.max) / 1000;
    return maxPrice + 5;
  }

  double get _selectedGrowthPercent {
    if (_historyPoints.length < 2) {
      return _selectedItem.diffPercentValue;
    }

    final firstPrice = _historyPoints.first.price;
    final lastPrice = _selectedHistoryPoint.price;
    if (firstPrice == 0) {
      return 0;
    }

    return ((lastPrice - firstPrice) / firstPrice) * 100;
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

  int _previousPrice(HargaPokokItem item) {
    return item.yesterdayPrice > 0 ? item.yesterdayPrice : item.price;
  }

  String _formatRupiah(int value) {
    return 'Rp${_rupiahFormat.format(value)}';
  }

  String _formatGrowth(double value) {
    final absoluteValue = value.abs();
    final formatted = absoluteValue >= 10
        ? absoluteValue.toStringAsFixed(0)
        : absoluteValue >= 1
        ? absoluteValue.toStringAsFixed(2)
        : absoluteValue.toStringAsFixed(2);
    return "$formatted%";
  }

  String _normalizeName(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}

class _HargaHistoryPoint {
  const _HargaHistoryPoint({required this.date, required this.price});

  final DateTime date;
  final int price;
}
