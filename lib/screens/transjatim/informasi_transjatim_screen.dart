import 'package:flutter/material.dart';

class InformasiTransjatimScreen extends StatefulWidget {
  const InformasiTransjatimScreen({super.key});

  @override
  State<InformasiTransjatimScreen> createState() =>
      _InformasiTransjatimScreenState();
}

class _InformasiTransjatimScreenState
    extends State<InformasiTransjatimScreen> {
  bool manfaatOpen = false;
  bool sistemOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Stack(
        children: [
          // 🔵 HEADER BACKGROUND
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/latar_belakang.png',
                ),
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
                          "Informasi",
                          textAlign: TextAlign.center,
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
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,
                      decoration:
                          const BoxDecoration(
                        color: Color(0xFFF7F7F7),
                        borderRadius:
                            BorderRadius.vertical(
                          top: Radius.circular(
                            34,
                          ),
                        ),
                      ),

                      child: Padding(
                        padding:
                            const EdgeInsets.all(20),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                            // 🔥 TOP IMAGE
                            Container(
                              width: double.infinity,
                              height: 160,

                              decoration:
                                  BoxDecoration(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  24,
                                ),

                                image:
                                    const DecorationImage(
                                  image: AssetImage(
                                    'assets/images/Top_transjatim.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 26),

                            const Text(
                              "Transjatim AJAIB 2.0",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight:
                                    FontWeight
                                        .bold,
                                color:
                                    Color(0xFF121938),
                              ),
                            ),

                            const SizedBox(
                                height: 10),

                            const Text(
                              "Inovasi digital Dishub Jatim yang menyediakan layanan transportasi publik terintegrasi",
                              style: TextStyle(
                                fontSize: 15,
                                color:
                                    Colors.grey,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(
                                height: 30),

                            const Text(
                              "Operasional",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight
                                        .bold,
                                color:
                                    Color(0xFF121938),
                              ),
                            ),

                            const SizedBox(
                                height: 20),

                            _infoCard(
                              title:
                                  "Link Layanan",
                              child: const Text(
                                "https://dishub.jatimprov.go.id",
                                style: TextStyle(
                                  color: Color(
                                    0xFF1565FF,
                                  ),
                                  fontSize: 15,
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 14),

                            _infoCard(
                              title: "Alamat",
                              child: const Text(
                                "Jl. Johar No.17, Alun-alun Contong, Kec. Bubutan, Surabaya, Jawa Timur 60174",
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      Colors.grey,
                                  height: 1.5,
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 14),

                            _infoCard(
                              title:
                                  "Jam Operasional",
                              child: const Text(
                                "Senin - Minggu (05.00 - 21.00)",
                                style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      Colors.grey,
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 14),

                            _infoCard(
                              title:
                                  "Media Sosial",
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons
                                        .smart_display,
                                    color: Color(
                                      0xFF1565FF,
                                    ),
                                  ),

                                  SizedBox(
                                      width:
                                          8),

                                  Text(
                                    "Youtube",
                                    style:
                                        TextStyle(
                                      color:
                                          Color(
                                        0xFF1565FF,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                      width:
                                          18),

                                  Icon(
                                    Icons
                                        .facebook,
                                    color: Color(
                                      0xFF1565FF,
                                    ),
                                  ),

                                  SizedBox(
                                      width:
                                          8),

                                  Text(
                                    "Facebook",
                                    style:
                                        TextStyle(
                                      color:
                                          Color(
                                        0xFF1565FF,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                      width:
                                          18),

                                  Icon(
                                    Icons
                                        .camera_alt,
                                    color: Color(
                                      0xFF1565FF,
                                    ),
                                  ),

                                  SizedBox(
                                      width:
                                          8),

                                  Text(
                                    "Instagram",
                                    style:
                                        TextStyle(
                                      color:
                                          Color(
                                        0xFF1565FF,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                                height: 34),

                            const Text(
                              "Ketentuan Umum",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight:
                                    FontWeight
                                        .bold,
                                color:
                                    Color(0xFF121938),
                              ),
                            ),

                            const SizedBox(
                                height: 20),

                            // 🔥 MANFAAT
                            _expandCard(
                              title: "Manfaat",
                              isOpen:
                                  manfaatOpen,

                              onTap: () {
                                setState(() {
                                  manfaatOpen =
                                      !manfaatOpen;
                                });
                              },

                              content:
                                  const Text(
                                "Memberikan kemudahan kepada Pengguna Transjatim untuk mengakses informasi terupdate terkait layanan Transjatim.",
                                style:
                                    TextStyle(
                                  fontSize:
                                      15,
                                  color:
                                      Colors
                                          .grey,
                                  height:
                                      1.6,
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 16),

                            // 🔥 SISTEM
                            _expandCard(
                              title:
                                  "Sistem, Mekanisme, dan Prosedur",

                              isOpen:
                                  sistemOpen,

                              onTap: () {
                                setState(() {
                                  sistemOpen =
                                      !sistemOpen;
                                });
                              },

                              content:
                                  const Text(
                                "1. Unduh aplikasi Transjatim Ajaib di Play Store dan App Store.\n\n"
                                "2. Tentukan tujuan perjalanan Anda lalu cek jadwal, rute, dan halte terdekat.\n\n"
                                "3. Beli tiket melalui aplikasi atau secara langsung di lokasi.\n\n"
                                "4. Pastikan naik sesuai halte dan rute yang dipilih.\n\n"
                                "5. Prioritaskan kursi untuk lansia, ibu hamil, dan penyandang disabilitas.",
                                style:
                                    TextStyle(
                                  fontSize:
                                      15,
                                  color:
                                      Colors
                                          .grey,
                                  height:
                                      1.6,
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 30),
                          ],
                        ),
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

  Widget _infoCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
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
              fontSize: 16,
              fontWeight:
                  FontWeight.w700,
              color: Color(0xFF121938),
            ),
          ),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }

  Widget _expandCard({
    required String title,
    required bool isOpen,
    required VoidCallback onTap,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Column(
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
                      fontSize: 16,
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

                  color:
                      const Color(
                    0xFF121938,
                  ),
                ),
              ],
            ),
          ),

          if (isOpen) ...[
            const SizedBox(height: 24),
            content,
          ],
        ],
      ),
    );
  }
}