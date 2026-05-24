import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../services/harga_pokok_service.dart';
import 'detail_bawang.dart';
import 'harga_malang.dart';
import 'informasi_harga.dart';

class HargaBahanPokokScreen extends StatefulWidget {
  const HargaBahanPokokScreen({super.key});

  @override
  State<HargaBahanPokokScreen> createState() => _HargaBahanPokokScreenState();
}

class _HargaBahanPokokScreenState extends State<HargaBahanPokokScreen> {
  final TextEditingController searchController = TextEditingController();
  final PageController _pageController = PageController(viewportFraction: 0.78);
  final HargaPokokService _hargaPokokService = HargaPokokService();

  int currentPage = 1;
  int _hargaPage = 1;
  int _hargaRequestSerial = 0;
  bool _isFetchingHarga = false;
  bool _hasLoadedHarga = false;
  Timer? _searchDebounce;

  List<HargaPokokItem> _hargaPokokItems = [];
  HargaPokokResponse? _hargaPokokResponse;

  static final NumberFormat _rupiahFormat = NumberFormat.decimalPattern(
    'id_ID',
  );

  static final List<HargaPokokItem> _fallbackHargaPokokItems = [
    HargaPokokItem(
      id: 39,
      name: 'Bawang Merah / kg',
      unit: 'kg',
      diff: 20,
      diffPercent: '20%',
      icon: 'down',
      imageUrl: 'assets/images/bawang_merah.png',
      price: 36418,
      yesterdayPrice: 0,
    ),
    HargaPokokItem(
      id: 49,
      name: 'Bawang Putih / kg',
      unit: 'kg',
      diff: 15,
      diffPercent: '15%',
      icon: 'up',
      imageUrl: 'assets/images/bawang_putih.png',
      price: 36418,
      yesterdayPrice: 0,
    ),
    HargaPokokItem(
      id: 4,
      name: 'Beras Medium / kg',
      unit: 'kg',
      diff: 20,
      diffPercent: '20%',
      icon: 'down',
      imageUrl: 'assets/images/beras.png',
      price: 36418,
      yesterdayPrice: 0,
    ),
    HargaPokokItem(
      id: 73,
      name: 'Besi Beton 10 mm (12/...',
      unit: 'Btg',
      diff: 15,
      diffPercent: '15%',
      icon: 'up',
      imageUrl: 'assets/images/besi.png',
      price: 36418,
      yesterdayPrice: 0,
    ),
    HargaPokokItem(
      id: 48,
      name: 'Buncis / kg',
      unit: 'kg',
      diff: 20,
      diffPercent: '20%',
      icon: 'down',
      imageUrl: 'assets/images/buncis.png',
      price: 36418,
      yesterdayPrice: 0,
    ),
  ];

  static final HargaPokokItem _fallbackRecommendation = HargaPokokItem(
    id: 38,
    name: 'Cabe Merah Besar',
    unit: 'kg',
    diff: 18,
    diffPercent: '18%',
    icon: 'up',
    imageUrl: 'assets/images/cabe.png',
    price: 0,
    yesterdayPrice: 0,
  );

  List<HargaPokokItem> get _visibleHargaPokokItems {
    if (_hasLoadedHarga) {
      return _hargaPokokItems;
    }
    return _fallbackHargaPokokItems;
  }

  HargaPokokItem get _recommendationItem {
    if (!_hasLoadedHarga) {
      return _fallbackRecommendation;
    }

    final items = _visibleHargaPokokItems;
    final risingItems = items.where((item) => item.isUp).toList()
      ..sort((a, b) => b.diffPercentValue.compareTo(a.diffPercentValue));

    if (risingItems.isNotEmpty) {
      return risingItems.first;
    }

    return items.isNotEmpty ? items.first : _fallbackHargaPokokItems.first;
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    _fetchHargaPokok();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _pageController.dispose();
    _hargaPokokService.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _fetchHargaPokok(reset: true);
    });
  }

  Future<void> _fetchHargaPokok({
    bool reset = false,
    bool append = false,
  }) async {
    if (_isFetchingHarga && append) {
      return;
    }

    final requestSerial = ++_hargaRequestSerial;
    final page = reset ? 1 : (append ? _hargaPage + 1 : _hargaPage);
    final keyword = searchController.text.trim();

    setState(() {
      _isFetchingHarga = true;
    });

    try {
      final response = await _hargaPokokService.getPrices(
        page: page,
        limit: 12,
        sort: 'name',
        name: keyword.isEmpty ? null : keyword,
      );

      if (!mounted || requestSerial != _hargaRequestSerial) {
        return;
      }

      setState(() {
        _hargaPokokResponse = response;
        _hargaPage = response.page == 0 ? page : response.page;
        _hasLoadedHarga = true;
        _isFetchingHarga = false;
        _hargaPokokItems = append
            ? [..._hargaPokokItems, ...response.priceList]
            : response.priceList;
      });
    } catch (_) {
      if (!mounted || requestSerial != _hargaRequestSerial) {
        return;
      }

      setState(() {
        _isFetchingHarga = false;
      });
    }
  }

  void _loadMoreHargaPokok() {
    final response = _hargaPokokResponse;
    if (_isFetchingHarga || (response != null && !response.hasNextPage)) {
      return;
    }

    _fetchHargaPokok(append: true);
  }

  @override
  Widget build(BuildContext context) {
    final recommendation = _recommendationItem;
    final priceItems = _visibleHargaPokokItems;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // HEADER
          Container(
            height: 180,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/latar_belakang.png"),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
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
                            "Harga Bahan Pokok",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const InfoHargaScreen(),
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
                ),

                const SizedBox(height: 10),

                // SEARCH
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey),
                        hintText: "Cari bahan pokok",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        // ========================
                        // PERBANDINGAN HARGA
                        // ========================
                        const Text(
                          "Perbandingan Harga",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF121938),
                          ),
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          height: 215,
                          child: PageView(
                            controller: _pageController,

                            onPageChanged: (index) {
                              setState(() {
                                currentPage = index;
                              });
                            },

                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 14),
                                child: _cityCard("Jember", false),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(right: 14),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DetailHargaMalangScreen(
                                          items: priceItems,
                                        ),
                                      ),
                                    );
                                  },
                                  child: _cityCard("Malang", true),
                                ),
                              ),

                              _cityCard("Kediri", false),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // DOT
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (index) => _dot(currentPage == index),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ========================
                        // REKOMENDASI
                        // ========================
                        const Text(
                          "Rekomendasi",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF121938),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEEF3),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.pink.shade100),
                          ),
                          child: Row(
                            children: [
                              _commodityImage(recommendation, width: 50),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Naik Signifikan",
                                      style: TextStyle(
                                        color: Colors.pink,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      recommendation.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color(0xFF121938),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          const TextSpan(
                                            text: "Rata-rata naik ",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          TextSpan(
                                            text: _formatPercent(
                                              recommendation.diffPercent,
                                            ),
                                            style: const TextStyle(
                                              color: Colors.pink,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                width: 72,
                                height: 42,
                                child: LineChart(
                                  LineChartData(
                                    minX: 0,
                                    maxX: 5,

                                    minY: 0,
                                    maxY: 5,

                                    titlesData: const FlTitlesData(show: false),

                                    borderData: FlBorderData(show: false),

                                    gridData: const FlGridData(show: false),

                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: const [
                                          FlSpot(0, 1),
                                          FlSpot(1, 2),
                                          FlSpot(2, 2),
                                          FlSpot(3, 3),
                                          FlSpot(4, 3),
                                          FlSpot(5, 4),
                                        ],

                                        isCurved: false,

                                        color: Colors.pink,

                                        barWidth: 2,

                                        dotData: const FlDotData(show: false),

                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: Colors.pink.withOpacity(0.10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 26),

                        // ========================
                        // KATEGORI
                        // ========================
                        const Text(
                          "Kategori",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF121938),
                          ),
                        ),

                        const SizedBox(height: 16),

                        GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.82,
                          children: [
                            _categoryItem("assets/images/beras.png", "Sembako"),
                            _categoryItem("assets/images/kol.png", "Sayuran"),
                            _categoryItem(
                              "assets/images/cabe.png",
                              "Buah -\nBuahan",
                            ),
                            _categoryItem(
                              "assets/images/daging.png",
                              "Daging &\nTelur",
                            ),
                            _categoryItem(
                              "assets/images/ikan.png",
                              "Ikan &\nSeafood",
                            ),
                            _categoryItem(
                              "assets/images/kayu.png",
                              "Bahan\nLainnya",
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // ========================
                        // DAFTAR
                        // ========================
                        const Text(
                          "Daftar Bahan Pokok",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF121938),
                          ),
                        ),

                        const SizedBox(height: 16),

                        ...priceItems.map(_productItem),

                        const SizedBox(height: 16),

                        GestureDetector(
                          onTap: _loadMoreHargaPokok,
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.03),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                "Bahan Lainnya",
                                style: TextStyle(
                                  color: Color(0xFF121938),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
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

  Widget _dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: active ? 32 : 10,
      height: 5,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF0E63FF) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _cityCard(String city, bool active) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: active ? const Color(0xFF0E63FF) : Colors.grey.shade300,
          width: active ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            city,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF121938),
            ),
          ),

          const SizedBox(height: 8),

          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "Rata-rata naik ",
                  style: TextStyle(color: Colors.grey),
                ),
                TextSpan(
                  text: "18%",
                  style: TextStyle(color: Colors.pink),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _priceRow("Beras", "Rp35.000", true),
          const Divider(),
          _priceRow("Cabe", "Rp15.000", false),
          const Divider(),
          _priceRow("Telur", "Rp20.000", true),

          const Spacer(),

          const Row(
            children: [
              Text("🔥", style: TextStyle(fontSize: 14)),
              SizedBox(width: 4),
              Text(
                "Komoditas naik: Cabai",
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String title, String price, bool up) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF121938),
          ),
        ),
        Row(
          children: [
            Text(
              price,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF121938),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              up ? Icons.arrow_upward : Icons.arrow_downward,
              size: 18,
              color: up ? Colors.green : Colors.pink,
            ),
          ],
        ),
      ],
    );
  }

  Widget _categoryItem(String image, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, width: 55, height: 55),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF121938),
            ),
          ),
        ],
      ),
    );
  }

  Widget _productItem(HargaPokokItem item) {
    final trendColor = item.isFlat
        ? Colors.grey
        : item.isDown
        ? Colors.green
        : Colors.pink;
    final trendIcon = item.isFlat
        ? Icons.remove
        : item.isDown
        ? Icons.arrow_downward
        : Icons.arrow_upward;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailBawangScreen(item: item)),
        );
      },
      child: Container(
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
              width: 72,
              height: 42,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 5,
                  minY: 0,
                  maxY: 5,

                  titlesData: const FlTitlesData(show: false),

                  borderData: FlBorderData(show: false),

                  gridData: const FlGridData(show: false),

                  lineBarsData: [
                    LineChartBarData(
                      spots: item.isFlat
                          ? const [
                              FlSpot(0, 3),
                              FlSpot(1, 3),
                              FlSpot(2, 3),
                              FlSpot(3, 3),
                              FlSpot(4, 3),
                              FlSpot(5, 3),
                            ]
                          : item.isDown
                          ? const [
                              FlSpot(0, 5),
                              FlSpot(1, 4),
                              FlSpot(2, 4),
                              FlSpot(3, 3),
                              FlSpot(4, 3),
                              FlSpot(5, 2),
                            ]
                          : const [
                              FlSpot(0, 1),
                              FlSpot(1, 2),
                              FlSpot(2, 2),
                              FlSpot(3, 3),
                              FlSpot(4, 3),
                              FlSpot(5, 4),
                            ],

                      isCurved: false,

                      color: trendColor,

                      barWidth: 2,

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
      ),
    );
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
}
