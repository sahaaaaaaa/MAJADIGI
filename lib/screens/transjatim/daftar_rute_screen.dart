import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'detail_rute_screen.dart';

class DaftarRuteScreen extends StatefulWidget {
  const DaftarRuteScreen({super.key});

  @override
  State<DaftarRuteScreen> createState() => _DaftarRuteScreenState();
}

class _DaftarRuteScreenState extends State<DaftarRuteScreen> {
  bool isJatim = true;

  final List<Map<String, String>> jatimRoutes = [
    {
      "code": "JTM1",
      "from": "Sidoarjo via Surabaya",
      "to": "Gresik",
      "time": "05.00-21.00",
      "color": "0xFF27AE60",
    },
    {
      "code": "JTM2",
      "from": "Surabaya",
      "to": "Mojokerto",
      "time": "04.00-21.00",
      "color": "0xFF1D9BF0",
    },
    {
      "code": "JTM3",
      "from": "Mojokerto",
      "to": "Gresik",
      "time": "05.00-21.00",
      "color": "0xFFE67E22",
    },
    {
      "code": "JTM4",
      "from": "Gresik",
      "to": "Lamongan",
      "time": "05.00-21.00",
      "color": "0xFFC9A227",
    },
    {
      "code": "JTML1",
      "from": "Gresik",
      "to": "Sidoarjo via Surabaya",
      "time": "06.00-18.00",
      "color": "0xFF8E24AA",
    },
    {
      "code": "JTML2",
      "from": "Terminal Bunder (OD)",
      "to": "Terminal Paciran (OD)",
      "time": "06.00-18.00",
      "color": "0xFFD946EF",
    },
    {
      "code": "JTM5",
      "from": "Surabaya",
      "to": "Bangkalan",
      "time": "05.00-21.00",
      "color": "0xFF0B2E83",
    },
    {
      "code": "JTM6",
      "from": "Sidoarjo",
      "to": "Mojokerto",
      "time": "04.00-21.00",
      "color": "0xFFE7A6C7",
    },
    {
      "code": "JTM7",
      "from": "Terminal Lamongan",
      "to": "Terminal Paciran",
      "time": "04.00-21.00",
      "color": "0xFF6D4C41",
    },
  ];

  final List<Map<String, String>> malangRoutes = [
    {
      "code": "MLG1",
      "from": "Terminal Hamid Rusdi",
      "to": "Terminal Batu",
      "time": "05.00-21.00",
      "color": "0xFF1565FF",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final routes = isJatim ? jatimRoutes : malangRoutes;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: Stack(
        children: [
          // 🔵 HEADER
          Container(
            width: double.infinity,
            height: 230,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/latar_belakang.png'),
                fit: BoxFit.cover,
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
                          "Daftar Rute",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
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
                        children: [
                          // TAB
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.grey.shade300),
                            ),

                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isJatim = true;
                                      });
                                    },

                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),

                                      decoration: BoxDecoration(
                                        color: isJatim
                                            ? const Color(0xFFDDE9F9)
                                            : Colors.transparent,

                                        borderRadius: BorderRadius.circular(24),
                                      ),

                                      child: Text(
                                        "Jatim",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: isJatim
                                              ? const Color(0xFF1565FF)
                                              : Colors.grey,

                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isJatim = false;
                                      });
                                    },

                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),

                                      decoration: BoxDecoration(
                                        color: !isJatim
                                            ? const Color(0xFFDDE9F9)
                                            : Colors.transparent,

                                        borderRadius: BorderRadius.circular(24),
                                      ),

                                      child: Text(
                                        "Malang",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: !isJatim
                                              ? const Color(0xFF1565FF)
                                              : Colors.grey,

                                          fontWeight: FontWeight.w600,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              isJatim ? "Jatim" : "Malang",

                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF121938),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          Expanded(
                            child: ListView.builder(
                              itemCount: routes.length,

                              itemBuilder: (context, index) {
                                final route = routes[index];

                                return _routeCard(
                                  code: route["code"]!,
                                  from: route["from"]!,
                                  to: route["to"]!,
                                  time: route["time"]!,
                                  color: Color(int.parse(route["color"]!)),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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

  Widget _routeCard({
    required String code,
    required String from,
    required String to,
    required String time,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                DetailRuteScreen(code: code, from: from, to: to, time: time),
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 18),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),

          border: Border.all(color: const Color(0xFFE5E5E5)),
        ),

        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),

              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: Text(
                          code,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        "TRANS JATIM",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),

                      const Spacer(),

                      SvgPicture.asset(
                        'assets/images/icons/switch-horizontal-02.svg',
                        width: 22,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Column(
                        children: [
                          SvgPicture.asset(
                            'assets/images/icons/ellipse.svg',
                            width: 14,
                          ),

                          Container(
                            width: 2,
                            height: 34,
                            color: const Color(0xFFD9D9D9),
                          ),

                          SvgPicture.asset(
                            'assets/images/icons/ellipse.svg',
                            width: 14,
                          ),
                        ],
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              from,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF121938),
                              ),
                            ),

                            const SizedBox(height: 34),

                            Text(
                              to,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF121938),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),

              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),

              child: Row(
                children: [
                  SvgPicture.asset('assets/images/icons/clock.svg', width: 18),

                  const SizedBox(width: 10),

                  Text(
                    time,
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
