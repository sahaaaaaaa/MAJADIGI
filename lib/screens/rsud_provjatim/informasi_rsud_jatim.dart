import 'package:flutter/material.dart';

class InformasiRsudScreen extends StatefulWidget {
  const InformasiRsudScreen({super.key});

  @override
  State<InformasiRsudScreen> createState() =>
      _InformasiRsudScreenState();
}

class _InformasiRsudScreenState
    extends State<InformasiRsudScreen> {
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
                                    'assets/images/Top_rsudjatim.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(
                                height: 26),

                            const Text(
                              "Tentang RSUD Haji Prov. Jatim",
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
                              "Informasi ketersediaan kamar rawat inap RSUD Haji Provinsi Jawa Timur",
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
                                "https://siskaperbapo.jatimprov.go.id/",
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
                                "Jl. Siwalankerto Utara II/42 Surabaya",
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
                                  "Jam Operasional",
                              child: const Text(
                                "Senin - Minggu (24 Jam)",
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
                                        .smart_display,
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
                                "Pendaftaran pasien online merupakan inovasi RSUD Haji Provinsi Jawa Timur yang menjadikan proses pelayanan lebih cepat dan efisien, baik dari sisi pasien maupun rumah sakit. Pasien juga bisa lebih mudah mengetahui jumlah ketersediaan kamar di RSUD Haji Provinsi Jawa Timur. Dengan sistem yang lebih tertata, pelayanan dan informasi rekam medis pasien lebih terorganisir. Pasien lebih mudah mengambil nomor antrian tanpa harus datang ke rumah sakit, juga bisa mengakses berbagai informasi penting kapanpun, dan dari manapun.",
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
                                "1. Ketik app.rsuhaji.jatimprov.go.id/online di mesin pencari perangkat Anda atau bisa langsung klik Pendaftaran Pasien Online RSUD Haji Provinsi Jawa Timur\n\n2. Pilih kategori layanan yang dituju (khusus member RSUD Haji Jatim)\n\n3. Jika Anda belum terdaftar sebagai member, silakan pilih menu pasien baru\n\n4. Isi formulir pendaftaran pasien online sampai selesai\n\nSyarat & Ketentuan pendaftaran pasien online:\n\n1. Pendaftaran online hanya berlaku bagi pasien yang sudah terdaftar sebagai member RSUD Haji Provinsi Jawa Timur\n\n2. Untuk pasien baru, silakan daftar sebagai member dengan memilih menu Pasien Baru di halaman registrasi online\n\n3. Khusus Pasien Baru Anak (belum punya KTP) bisa menuliskan NIK yang tertera di Kartu Keluarga, dan mengupload foto KK sebagai ganti foto KTP\n\n4. Pilih menu Medical Checkup untuk layanan vaksin dan medical check up (CPNS)\n\n5. Pendaftaran online untuk layanan vaksin dan medical check up (CPNS) bisa dilakukan baik oleh pasien yang sudah terdaftar sebagai member maupun belum\n\n6. Pendaftaran online hanya bisa dilakukan satu kali sampai layanan di poli selesai\n\n7. Pendaftaran online belum bisa digunakan untuk asuransi pihak ketiga",
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