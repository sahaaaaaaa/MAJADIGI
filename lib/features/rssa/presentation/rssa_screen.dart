import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:majadigi/features/rsud_provjatim/data/rsud_saiful_anwar_service.dart';
import 'package:majadigi/core/widgets/layanan_favorite_button.dart';
import 'package:majadigi/features/rssa/presentation/informasi_rssa_screen.dart';

class RssaScreen extends StatefulWidget {
  const RssaScreen({super.key});

  @override
  State<RssaScreen> createState() => _RssaScreenState();
}

class _RssaScreenState extends State<RssaScreen> {
  final PageController _pageController = PageController();
  final RsudSaifulAnwarService _rsudSaifulAnwarService =
      RsudSaifulAnwarService();

  int currentPage = 0;
  Timer? _sliderTimer;
  RsudSaifulAnwarOccupancy? _occupancy;

  final List<String> images = [
    'assets/images/rssa1.png',
    'assets/images/rssa2.png',
    'assets/images/rssa3.png',
  ];

  static const List<Color> _roomColors = [
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.orange,
    Colors.lightBlue,
    Colors.pink,
    Colors.blue,
  ];

  static const RsudSaifulAnwarOccupancy _fallbackOccupancy =
      RsudSaifulAnwarOccupancy(
        summary: RsudSaifulAnwarSummary(
          total: 909,
          occupied: 666,
          available: 220,
          lastUpdate: '2026-04-07 07:13:45',
        ),
        rooms: [
          RsudSaifulAnwarRoom(
            name: 'HCU',
            type: '',
            total: 10,
            occupied: 10,
            available: 0,
          ),
          RsudSaifulAnwarRoom(
            name: 'ICCU/ICVCU Dengan Ventilator',
            type: '',
            total: 10,
            occupied: 10,
            available: 0,
          ),
          RsudSaifulAnwarRoom(
            name: 'ICCU/ICVCU Tanpa Ventilator',
            type: '',
            total: 10,
            occupied: 10,
            available: 0,
          ),
          RsudSaifulAnwarRoom(
            name: 'ICU Dengan Ventilator',
            type: '',
            total: 10,
            occupied: 10,
            available: 0,
          ),
          RsudSaifulAnwarRoom(
            name: 'ISOLASI',
            type: '',
            total: 10,
            occupied: 10,
            available: 0,
          ),
          RsudSaifulAnwarRoom(
            name: 'Intermediate Ward (IGD)',
            type: '',
            total: 10,
            occupied: 10,
            available: 0,
          ),
          RsudSaifulAnwarRoom(
            name: 'Isolasi Tekanan Negatif',
            type: '',
            total: 10,
            occupied: 10,
            available: 0,
          ),
          RsudSaifulAnwarRoom(
            name: 'KELAS I',
            type: '',
            total: 10,
            occupied: 10,
            available: 0,
          ),
          RsudSaifulAnwarRoom(
            name: 'KELAS II',
            type: '',
            total: 10,
            occupied: 10,
            available: 0,
          ),
          RsudSaifulAnwarRoom(
            name: 'KELAS III',
            type: '',
            total: 10,
            occupied: 10,
            available: 0,
          ),
        ],
      );

  RsudSaifulAnwarSummary get _summary {
    return _occupancy?.summary ?? _fallbackOccupancy.summary;
  }

  List<RsudSaifulAnwarRoom> get _rooms {
    final rooms = _occupancy?.rooms ?? const [];
    return rooms.isEmpty ? _fallbackOccupancy.rooms : rooms;
  }

  @override
  void initState() {
    super.initState();
    _loadRoomOccupancy();

    _sliderTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        currentPage = (currentPage + 1) % images.length;

        _pageController.animateToPage(
          currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
    _rsudSaifulAnwarService.dispose();
    super.dispose();
  }

  Future<void> _loadRoomOccupancy() async {
    try {
      final occupancy = await _rsudSaifulAnwarService.getRoomOccupancy();
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
          // 🔵 HEADER BG
          Container(
            width: double.infinity,
            height: 600,
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
                          "RSUD Dr Saiful Anwar",
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
                            serviceName: 'RSUD Dr. Saiful Anwar',
                            lookupQuery: 'Saiful Anwar',
                          ),

                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const InformasiRssaScreen(),
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
                        // 🔥 SLIDER
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

                                // 🔥 TOTAL
                                _bigCard(),

                                const SizedBox(height: 14),

                                Row(
                                  children: [
                                    Expanded(
                                      child: _smallCard(
                                        _summary.available.toString(),
                                        "Tersedia",
                                        Colors.green,
                                        'assets/images/icons/users-check.svg',
                                      ),
                                    ),

                                    const SizedBox(width: 14),

                                    Expanded(
                                      child: _smallCard(
                                        _summary.occupied.toString(),
                                        "Terisi",
                                        Colors.orange,
                                        'assets/images/icons/users-up-01.svg',
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

                                Row(
  children: [
    _barColor(const Color(0xFF27AE60)),
    _barColor(const Color(0xFF1565FF)),
    _barColor(const Color(0xFFA142F4)),
    _barColor(const Color(0xFFF5A623)),
    _barColor(const Color(0xFF149CE6)),
    _barColor(const Color(0xFFFF0054)),
    _barColor(const Color(0xFF0050C8)),
  ],
),

                                const SizedBox(height: 14),

                                // 🔥 TABLE
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
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // ===== KOLOM RUANG (STICKY) =====
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

      // ===== KOLOM ANGKA (SCROLLABLE) =====
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
  return Expanded(
    child: Container(
      height: 16,
      color: color,
    ),
  );
}

  Widget _bigCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _summary.total.toString(),
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF121938),
                ),
              ),

              const Text("Total Kamar Rawat", style: TextStyle(fontSize: 15)),
            ],
          ),

          SvgPicture.asset('assets/images/icons/building-07.svg', width: 32),
        ],
      ),
    );
  }

  Widget _smallCard(String value, String label, Color color, String icon) {
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
                  color: color,
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
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
  );
}

Widget _roomNameCell(
  RsudSaifulAnwarRoom room,
  Color color,
) {
  return Container(
    height: 72,
    padding: const EdgeInsets.symmetric(
      horizontal: 16,
    ),

    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
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
            style: const TextStyle(fontSize: 14),
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
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        SizedBox(
          width: 120,
          child: Center(
            child: Text(
              "Terisi",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        SizedBox(
          width: 120,
          child: Center(
            child: Text(
              "Tersedia",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _tableRow(
  RsudSaifulAnwarRoom room,
) {
  return Container(
    height: 72,

    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Colors.grey.shade300,
        ),
      ),
    ),

    child: Row(
      children: [
        SizedBox(
          width: 120,
          child: Center(
            child: Text(
              room.total.toString(),
            ),
          ),
        ),

        SizedBox(
          width: 120,
          child: Center(
            child: Text(
              room.occupied.toString(),
              style: TextStyle(
                color: Colors.orange.shade700,
              ),
            ),
          ),
        ),

        SizedBox(
          width: 120,
          child: Center(
            child: Text(
              room.available.toString(),
              style: const TextStyle(
                color: Colors.green,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  DataRow _roomRow(RsudSaifulAnwarRoom room, Color color) {
    return DataRow(
      cells: [
        DataCell(
          Row(
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
                child: Text(room.name, style: const TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ),

        DataCell(Text(room.total.toString())),

        DataCell(
          Text(
            room.occupied.toString(),
            style: TextStyle(color: Colors.orange.shade700),
          ),
        ),

        DataCell(
          Text(
            room.available.toString(),
            style: const TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }
}
