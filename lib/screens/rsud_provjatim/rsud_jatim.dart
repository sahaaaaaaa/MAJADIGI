import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../services/rsud_haji_service.dart';
import '../../widgets/layanan_favorite_button.dart';
import 'informasi_rsud_jatim.dart';

class RsudHajiScreen extends StatefulWidget {
  const RsudHajiScreen({super.key});

  @override
  State<RsudHajiScreen> createState() => _RsudHajiScreenState();
}

class _RsudHajiScreenState extends State<RsudHajiScreen> {
  final PageController _pageController = PageController();
  final RsudHajiService _rsudHajiService = RsudHajiService();
  int currentPage = 1;
  RsudHajiOccupancy? _occupancy;

  final List<String> images = [
    'assets/images/rsud1.png',
    'assets/images/rsud2.png',
    'assets/images/rsud3.png',
  ];

  static const List<Color> _roomColors = [
    Color(0xFF27AE60),
    Color(0xFF1565FF),
    Color(0xFFA142F4),
    Color(0xFFF5A623),
    Color(0xFF149CE6),
    Color(0xFFFF0054),
    Color(0xFF0050C8),
  ];

  static const RsudHajiOccupancy _fallbackOccupancy = RsudHajiOccupancy(
    summary: RsudHajiSummary(
      total: 306,
      occupied: 230,
      available: 76,
      lastUpdate: '2026-04-06 11:55:55',
    ),
    rooms: [
      RsudHajiRoom(name: 'HCU', total: 10, occupied: 10, available: 0),
      RsudHajiRoom(
        name: 'ICCU/ICVCU Dengan Ventilator',
        total: 10,
        occupied: 10,
        available: 0,
      ),
      RsudHajiRoom(
        name: 'ICCU/ICVCU Tanpa Ventilator',
        total: 10,
        occupied: 10,
        available: 0,
      ),
      RsudHajiRoom(
        name: 'ICU Dengan Ventilator',
        total: 10,
        occupied: 10,
        available: 0,
      ),
      RsudHajiRoom(name: 'ISOLASI', total: 10, occupied: 10, available: 0),
      RsudHajiRoom(
        name: 'Intermediate Ward (IGD)',
        total: 10,
        occupied: 10,
        available: 0,
      ),
      RsudHajiRoom(
        name: 'Isolasi Tekanan Negatif',
        total: 10,
        occupied: 10,
        available: 0,
      ),
      RsudHajiRoom(name: 'KELAS I', total: 10, occupied: 10, available: 0),
      RsudHajiRoom(name: 'KELAS II', total: 10, occupied: 10, available: 0),
      RsudHajiRoom(name: 'KELAS III', total: 10, occupied: 10, available: 0),
    ],
  );

  RsudHajiSummary get _summary {
    return _occupancy?.summary ?? _fallbackOccupancy.summary;
  }

  List<RsudHajiRoom> get _rooms {
    final rooms = _occupancy?.rooms ?? const [];
    return rooms.isEmpty ? _fallbackOccupancy.rooms : rooms;
  }

  @override
  void initState() {
    super.initState();
    _loadRoomOccupancy();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _rsudHajiService.dispose();
    super.dispose();
  }

  Future<void> _loadRoomOccupancy() async {
    try {
      final occupancy = await _rsudHajiService.getRoomOccupancy();
      if (!mounted) {
        return;
      }
      setState(() {
        _occupancy = occupancy;
      });
    } catch (_) {}
  }

  Color _roomColor(int index) {
    return _roomColors[index % _roomColors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Stack(
        children: [
          // 🔵 HEADER BACKGROUND
          Container(
            width: double.infinity,
            height: 600,
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
                          const LayananFavoriteButton(
                            serviceName: 'RSUD Haji',
                            lookupQuery: 'RSUD Haji',
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            images.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: currentPage == index ? 30 : 10,
                              height: 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: currentPage == index
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
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(34),
                            ),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),

                                const Text(
                                  "Ketersediaan Kamar Rawat",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF121938),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _summary.lastUpdate,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 18),

                                // 🔥 CARD TOTAL
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),

                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _summary.total.toString(),
                                            style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF121938),
                                            ),
                                          ),

                                          const Text(
                                            "Total Kamar Rawat",
                                            style: TextStyle(fontSize: 15),
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

                                const SizedBox(height: 14),

                                // 🔥 TERSEDIA TERISI
                                Row(
                                  children: [
                                    Expanded(
                                      child: _smallCard(
                                        value: _summary.available.toString(),
                                        label: "Tersedia",
                                        icon:
                                            'assets/images/icons/users-check.svg',
                                        valueColor: const Color(0xFF27AE60),
                                      ),
                                    ),

                                    const SizedBox(width: 14),

                                    Expanded(
                                      child: _smallCard(
                                        value: _summary.occupied.toString(),
                                        label: "Terisi",
                                        icon:
                                            'assets/images/icons/users-up-01.svg',
                                        valueColor: const Color(0xFFFF6B00),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                const Text(
                                  "Status Ketersediaan Ruangan",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF121938),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // 🔥 BAR WARNA
                                Row(
                                  children: _rooms
                                      .asMap()
                                      .keys
                                      .map(
                                        (index) => _barColor(_roomColor(index)),
                                      )
                                      .toList(),
                                ),

                                const SizedBox(height: 14),

                                // 🔥 TABLE
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),

                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ===== RUANG (STICKY) =====
                                      Container(
                                        width: 250,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            _roomHeader(),
                                            ..._rooms.asMap().entries.map(
                                              (entry) => _roomNameCell(
                                                entry.value,
                                                _roomColor(entry.key),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // ===== DATA SCROLL =====
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Column(
                                            children: [
                                              _tableHeader(),
                                              ..._rooms.map(
                                                (room) => _tableRow(room),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _barColor(Color color) {
    return Expanded(child: Container(height: 16, color: color));
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
        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),

              SvgPicture.asset(icon, width: 22),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF121938)),
          ),
        ],
      ),
    );
  }

  Widget _roomHeader() {
    return Container(
      height: 56,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: const Text(
        "Ruang",
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }

  Widget _roomNameCell(RsudHajiRoom room, Color color) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              room.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Container(
      height: 56,
      child: const Row(
        children: [
          SizedBox(
            width: 120,
            child: Center(
              child: Text(
                "Kapasitas",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Center(
              child: Text(
                "Terisi",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Center(
              child: Text(
                "Tersedia",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableRow(RsudHajiRoom room) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Center(child: Text(room.total.toString())),
          ),
          SizedBox(
            width: 120,
            child: Center(
              child: Text(
                room.occupied.toString(),
                style: const TextStyle(color: Color(0xFFFF6B00)),
              ),
            ),
          ),
          SizedBox(
            width: 120,
            child: Center(
              child: Text(
                room.available.toString(),
                style: const TextStyle(color: Color(0xFF27AE60)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
