import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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

  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // HEADER
          // Latar Belakang Biru
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/latar_belakang.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
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
                                        builder: (_) =>
                                            const DetailHargaMalangScreen(),
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
                              Image.asset("assets/images/cabe.png", width: 50),

                              const SizedBox(width: 14),

                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Naik Signifikan",
                                      style: TextStyle(
                                        color: Colors.pink,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Cabe Merah Besar",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Color(0xFF121938),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Rata-rata naik ",
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "18%",
                                            style: TextStyle(
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

                        _productItem(
                          "assets/images/bawang_merah.png",
                          "Bawang Merah / kg",
                          "20%",
                          true,
                        ),

                        _productItem(
                          "assets/images/bawang_putih.png",
                          "Bawang Putih / kg",
                          "15%",
                          false,
                        ),

                        _productItem(
                          "assets/images/beras.png",
                          "Beras Medium / kg",
                          "20%",
                          true,
                        ),

                        _productItem(
                          "assets/images/besi.png",
                          "Besi Beton 10 mm (12/...",
                          "15%",
                          false,
                        ),

                        _productItem(
                          "assets/images/buncis.png",
                          "Buncis / kg",
                          "20%",
                          true,
                        ),

                        const SizedBox(height: 16),

                        Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
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

  Widget _productItem(String image, String title, String percent, bool up) {
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
                        color: up ? Colors.green : Colors.pink,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      up ? Icons.arrow_downward : Icons.arrow_upward,
                      color: up ? Colors.green : Colors.pink,
                      size: 18,
                    ),
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
                    spots: up
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

                    color: up ? Colors.green : Colors.pink,

                    barWidth: 2,

                    dotData: const FlDotData(show: false),

                    belowBarData: BarAreaData(
                      show: true,
                      color: (up ? Colors.green : Colors.pink).withOpacity(
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
