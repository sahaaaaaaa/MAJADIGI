import 'package:flutter/material.dart';

class InformasiRssaScreen extends StatefulWidget {
  const InformasiRssaScreen({super.key});

  @override
  State<InformasiRssaScreen> createState() =>
      _InformasiRssaScreenState();
}

class _InformasiRssaScreenState
    extends State<InformasiRssaScreen> {
  bool manfaatOpen = false;
  bool sistemOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Stack(
        children: [
          // BACKGROUND HEADER
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/latar_belakang.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // HEADER
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
                            Navigator.pop(
                                context);
                          },
                          icon: const Icon(
                            Icons
                                .arrow_back_ios_new,
                            color:
                                Colors.white,
                          ),
                        ),

                        const Expanded(
                          child: Text(
                            "Informasi",
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 20,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),
                        ),

                        const SizedBox(
                            width: 40),
                      ],
                    ),
                  ),

                  // BODY
                  Container(
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
                          const EdgeInsets.all(
                        20,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [
                          // TOP IMAGE
                          Container(
                            width:
                                double.infinity,
                            height: 150,

                            decoration:
                                BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(
                                24,
                              ),

                              image:
                                  const DecorationImage(
                                image: AssetImage(
                                  'assets/images/Top_rssa.png',
                                ),

                                fit:
                                    BoxFit.cover,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 26),

                          const Text(
                            "Tentang RSUD Dr Saiful Anwar",

                            style: TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              color: Color(
                                0xFF121938,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 10),

                          const Text(
                            "Informasi ketersediaan kamar rawat inap RSUD Dr Saiful Anwar.",

                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              color: Color(
                                0xFF666666,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 32),

                          // ================= OPERATIONAL =================

                          const Text(
                            "Operational",

                            style: TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight
                                      .w700,
                              color: Color(
                                0xFF121938,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 20),

                          _infoCard(
                            title:
                                "Link Layanan",

                            child:
                                const Text(
                              "https://rsusaifulanwar.jatimprov.go.id/v2/",

                              style:
                                  TextStyle(
                                color: Colors
                                    .blue,
                                fontSize:
                                    16,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 16),

                          _infoCard(
                            title: "Alamat",

                            child:
                                const Text(
                              "Jl. Jaksa Agung Suprapto No.2, Klojen, Kec. Klojen, Kota Malang, Jawa Timur",

                              style:
                                  TextStyle(
                                fontSize:
                                    16,
                                color:
                                    Color(
                                  0xFF666666,
                                ),
                                height:
                                    1.5,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 16),

                          _infoCard(
                            title:
                                "Jam Operasional",

                            child:
                                const Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [
                                Text(
                                  "• Senin - Kamis (07.00 - 13.30)",

                                  style:
                                      TextStyle(
                                    fontSize:
                                        16,
                                    color:
                                        Color(
                                      0xFF666666,
                                    ),
                                  ),
                                ),

                                SizedBox(
                                    height:
                                        8),

                                Text(
                                  "• Jumat (07.00 - 11.00)",

                                  style:
                                      TextStyle(
                                    fontSize:
                                        16,
                                    color:
                                        Color(
                                      0xFF666666,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                              height: 16),

                          _infoCard(
                            title:
                                "Media Sosial",

                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,

                              children: const [
                                Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .smart_display,
                                      color:
                                          Colors.blue,
                                    ),

                                    SizedBox(
                                        width:
                                            8),

                                    Text(
                                      "Youtube",

                                      style:
                                          TextStyle(
                                        color:
                                            Colors.blue,
                                        fontSize:
                                            16,
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .facebook,
                                      color:
                                          Colors.blue,
                                    ),

                                    SizedBox(
                                        width:
                                            8),

                                    Text(
                                      "Facebook",

                                      style:
                                          TextStyle(
                                        color:
                                            Colors.blue,
                                        fontSize:
                                            16,
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .camera_alt,
                                      color:
                                          Colors.blue,
                                    ),

                                    SizedBox(
                                        width:
                                            8),

                                    Text(
                                      "Instagram",

                                      style:
                                          TextStyle(
                                        color:
                                            Colors.blue,
                                        fontSize:
                                            16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                              height: 34),

                          // ================= KETENTUAN =================

                          const Text(
                            "Ketentuan Umum",

                            style: TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight
                                      .w700,
                              color: Color(
                                0xFF121938,
                              ),
                            ),
                          ),

                          const SizedBox(
                              height: 20),

                          _expandCard(
                            "Manfaat",
                            manfaatOpen,
                            () {
                              setState(
                                () {
                                  manfaatOpen =
                                      !manfaatOpen;
                                },
                              );
                            },
                          ),

                          const SizedBox(
                              height: 16),

                          _expandCard(
                            "Sistem, Mekanisme, dan Prosedur",
                            sistemOpen,
                            () {
                              setState(
                                () {
                                  sistemOpen =
                                      !sistemOpen;
                                },
                              );
                            },
                          ),

                          const SizedBox(
                              height: 30),
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
    );
  }

  Widget _infoCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(
        20,
      ),

      decoration: BoxDecoration(
        color: const Color(
          0xFFF8F8F8,
        ),

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.w700,
              color:
                  Color(0xFF121938),
            ),
          ),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }

  Widget _expandCard(
    String title,
    bool isOpen,
    VoidCallback onTap,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(
        20,
      ),

      decoration: BoxDecoration(
        color: const Color(
          0xFFF8F8F8,
        ),

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color:
              const Color(0xFFD9D9D9),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          GestureDetector(
            onTap: onTap,

            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,

                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight
                              .w700,
                      color: Color(
                        0xFF121938,
                      ),
                    ),
                  ),
                ),

                Icon(
                  isOpen
                      ? Icons.remove
                      : Icons.add,

                  size: 24,
                ),
              ],
            ),
          ),

          if (isOpen) ...[
            const SizedBox(height: 20),

            const Text(
              "Isi informasi...",
            ),
          ],
        ],
      ),
    );
  }
}