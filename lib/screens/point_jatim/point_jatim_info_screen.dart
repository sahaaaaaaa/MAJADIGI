import 'package:flutter/material.dart';

class PointJatimInfoScreen extends StatefulWidget {
  const PointJatimInfoScreen({super.key});

  @override
  State<PointJatimInfoScreen> createState() =>
      _PointJatimInfoScreenState();
}

class _PointJatimInfoScreenState
    extends State<PointJatimInfoScreen> {

  bool manfaatExpanded = false;
  bool sistemExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1E4FD8),

      body: Stack(
        children: [

          /// BACKGROUND
          Container(
            width: double.infinity,
            height: 260,

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

          Column(
            children: [

              /// APPBAR
              _buildAppBar(),

              const SizedBox(height: 10),

              /// BODY
              Expanded(
                child: Container(
                  width: double.infinity,

                  decoration: const BoxDecoration(
                    color: Color(0xffF7F7F7),

                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(34),
                      topRight: Radius.circular(34),
                    ),
                  ),

                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        /// LOGO CARD
                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 28,
                          ),

                          decoration: BoxDecoration(
                            color: const Color(0xffEEF3FF),
                            borderRadius:
                                BorderRadius.circular(22),
                            border: Border.all(
                              color: const Color(
                                0xffC9D8FF,
                              ),
                            ),
                          ),

                          child: Center(
                            child: Image.asset(
                              'assets/images/point_jatim.png',
                              height: 60,
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        /// TITLE
                        const Text(
                          'Peluang Investasi Proyek Jatim (POINT JATIM)',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1D1D1D),
                            height: 1.3,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'Platform digital berbasis WebGIS yang menyajikan peta interaktif berisi potensi dan peluang investasi di seluruh wilayah Jawa Timur.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.7,
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// OPERASIONAL
                        const Text(
                          'Operasional',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 18),

                        _buildInfoCard(
                          title: 'Link Layanan',

                          child: Text(
                            'https://point.jatimprov.go.id/',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 13,
                            ),
                          ),
                        ),

                        _buildInfoCard(
                          title: 'Alamat',

                          child: Text(
                            'Jl. Pahlawan No.116, Krembangan Sel., Kec. Krembangan, Surabaya, Jawa Timur 60175',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              height: 1.6,
                              fontSize: 13,
                            ),
                          ),
                        ),

                        _buildInfoCard(
                          title: 'Jam Operasional',

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              _buildBulletText(
                                'Senin - Kamis (08.00 - 15.30)',
                              ),

                              const SizedBox(height: 6),

                              _buildBulletText(
                                'Jumat (08.00 - 14.00)',
                              ),
                            ],
                          ),
                        ),

                        _buildInfoCard(
                          title: 'Media Sosial',

                          child: Row(
                            children: [

                              Icon(
                                Icons.camera_alt,
                                color: Colors.blue.shade700,
                                size: 18,
                              ),

                              const SizedBox(width: 6),

                              Text(
                                'Instagram',
                                style: TextStyle(
                                  color:
                                      Colors.blue.shade700,
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(width: 22),

                              Icon(
                                Icons.facebook,
                                color: Colors.blue.shade700,
                                size: 18,
                              ),

                              const SizedBox(width: 6),

                              Text(
                                'Facebook',
                                style: TextStyle(
                                  color:
                                      Colors.blue.shade700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// KETENTUAN
                        const Text(
                          'Ketentuan Umum',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// MANFAAT
                        _buildExpandTile(
                          title: 'Manfaat',

                          isExpanded: manfaatExpanded,

                          onTap: () {
                            setState(() {
                              manfaatExpanded =
                                  !manfaatExpanded;
                            });
                          },

                          content: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Text(
                                'Investasi merupakan salah satu pilar penguatan ekonomi daerah terutama Jawa Timur. Melalui POINT JATIM memiliki berbagai manfaat, antara lain:',
                                style: TextStyle(
                                  color:
                                      Colors.grey.shade700,
                                  fontSize: 13,
                                  height: 1.7,
                                ),
                              ),

                              const SizedBox(height: 18),

                              _buildNumberText(
                                1,
                                'Kemudahan akses informasi bagi pemerintah daerah, investor, dan masyarakat terhadap informasi potensi investasi secara digital dan tervalidasi.',
                              ),

                              _buildNumberText(
                                2,
                                'Efektivitas promosi investasi melalui fitur interaktif yang tersedia seperti peta kawasan industri, informasi kegiatan, hingga webinar yang relevan.',
                              ),

                              _buildNumberText(
                                3,
                                'Optimalisasi peluang kerja sama investasi, baik lokal maupun internasional, melalui pembaruan data potensi ekonomi daerah yang dilakukan secara berkala dan akurat.',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// SISTEM
                        _buildExpandTile(
                          title:
                              'Sistem, Mekanisme, dan Prosedur',

                          isExpanded: sistemExpanded,

                          onTap: () {
                            setState(() {
                              sistemExpanded =
                                  !sistemExpanded;
                            });
                          },

                          content: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              const Text(
                                'Persyaratan',
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 12),

                              _buildNumberText(
                                1,
                                'Pengguna harus memiliki akses internet untuk mengakses platform WebGIS POINT JATIM.',
                              ),

                              _buildNumberText(
                                2,
                                'Data peta dan informasi potensi investasi yang diperbarui oleh pemerintah daerah diperlukan untuk analisis peluang investasi.',
                              ),

                              const SizedBox(height: 20),

                              const Text(
                                'Sistem',
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 12),

                              _buildNumberText(
                                1,
                                'Berbasis WebGIS dengan fitur overlay peta kawasan industri serta event promosi investasi.',
                              ),

                              _buildNumberText(
                                2,
                                'Terintegrasi dengan data statistik dan informasi demografi untuk gambaran potensi investasi wilayah.',
                              ),

                              const SizedBox(height: 20),

                              const Text(
                                'Mekanisme',
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 12),

                              _buildNumberText(
                                1,
                                'Pengguna dapat mencari dan mengakses informasi peluang investasi berdasarkan wilayah.',
                              ),

                              _buildNumberText(
                                2,
                                'Pemerintah daerah memperbarui peta potensi investasi mereka, sementara investor dapat menelusuri dan menganalisis data investasi yang tersedia.',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// APPBAR
  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        55,
        16,
        0,
      ),

      child: Row(
        children: [

          InkWell(
            onTap: () {
              Navigator.pop(context);
            },

            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 18,
            ),
          ),

          const Expanded(
            child: Center(
              child: Text(
                'Informasi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(width: 18),
        ],
      ),
    );
  }

  /// INFO CARD
  Widget _buildInfoCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xffF3F3F3),
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 12),

          child,
        ],
      ),
    );
  }

  /// EXPAND TILE
  Widget _buildExpandTile({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: isExpanded
            ? const Color(0xffF3F3F3)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: isExpanded
            ? const Color(0xffE4E4E4)
            : Colors.grey.shade300,
        ),
      ),

      child: Column(
        children: [

          InkWell(
            onTap: onTap,

            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),

              child: Row(
                children: [

                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  Icon(
                    isExpanded
                        ? Icons.remove
                        : Icons.add,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          if (isExpanded)
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                18,
                0,
                18,
                18,
              ),

              child: content,
            ),
        ],
      ),
    );
  }

  Widget _buildBulletText(String text) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Text(
          '• ',
          style: TextStyle(
            color: Colors.grey.shade700,
          ),
        ),

        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberText(
  int number,
  String text,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),

    child: Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Text(
          '$number. ',
          style: TextStyle(
            color: Colors.grey.shade700,
            height: 1.7,
            fontSize: 13,
          ),
        ),

        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
              height: 1.7,
            ),
          ),
        ),
      ],
    ),
  );
}
    }