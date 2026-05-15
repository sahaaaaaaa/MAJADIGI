import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DaftarTiketScreen
    extends StatelessWidget {
  const DaftarTiketScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent,

      body: Stack(
        children: [
          // 🔵 HEADER BG
          Container(
            width: double.infinity,
            height: 240,
            decoration:
                const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/latar_belakang.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 🔹 HEADER
                Padding(
                  padding:
                      const EdgeInsets.symmetric(
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
                          "Daftar Tiket",
                          textAlign:
                              TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    width:
                        double.infinity,
                    decoration:
                        const BoxDecoration(
                      color: Color(
                        0xFFF5F5F5,
                      ),
                      borderRadius:
                          BorderRadius.vertical(
                        top:
                            Radius.circular(
                          34,
                        ),
                      ),
                    ),

                    child: Padding(
                      padding:
                          const EdgeInsets
                              .all(16),
                      child: ListView(
                        children: [
                          const SizedBox(
                              height: 8),

                          const Text(
                            "Umum",
                            style:
                                TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              color: Color(
                                0xFF121938,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 16),

                          _ticketCard(
                            icon:
                                'assets/images/icons/users-03.svg',
                            title:
                                "Umum",
                            price:
                                "Rp5.000",
                          ),

                          const SizedBox(
                              height: 12),

                          _ticketCard(
                            icon:
                                'assets/images/icons/users-03.svg',
                            title:
                                "Pelajar",
                            price:
                                "Rp2.500",
                          ),

                          const SizedBox(
                              height: 28),

                          const Text(
                            "Luxury",
                            style:
                                TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              color: Color(
                                0xFF121938,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 16),

                          _ticketCard(
                            icon:
                                'assets/images/icons/bus.svg',
                            title:
                                "SBY - GSK",
                            price:
                                "Rp20.000",
                          ),

                          const SizedBox(
                              height: 12),

                          _ticketCard(
                            icon:
                                'assets/images/icons/bus.svg',
                            title:
                                "SBY - SDA",
                            price:
                                "Rp15.000",
                          ),

                          const SizedBox(
                              height: 12),

                          _ticketCard(
                            icon:
                                'assets/images/icons/bus.svg',
                            title:
                                "SDA - GSK",
                            price:
                                "Rp30.000",
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

  Widget _ticketCard({
    required String icon,
    required String title,
    required String price,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 24,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w600,
                color: Color(
                  0xFF121938,
                ),
              ),
            ),
          ),

          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: price,
                  style: const TextStyle(
                    color: Color(
                      0xFF121938,
                    ),
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const TextSpan(
                  text: " / Tiket",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}