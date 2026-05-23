import 'package:flutter/material.dart';
import 'islamic_center_home_screen.dart';

class IslamicCenterInfoScreen
    extends StatefulWidget {

  const IslamicCenterInfoScreen({
    super.key,
  });

  @override
  State<IslamicCenterInfoScreen>
      createState() =>
          _IslamicCenterInfoScreenState();
}

class _IslamicCenterInfoScreenState
    extends State<IslamicCenterInfoScreen> {

  bool manfaatExpand = false;
  bool sistemExpand = false;

  final ScrollController
      scrollController =
          ScrollController();

  final GlobalKey ketentuanKey =
      GlobalKey();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(0xff1E4FD8),

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

                  decoration:
                      const BoxDecoration(
                    color: Color(
                      0xffF7F7F7,
                    ),

                    borderRadius:
                        BorderRadius.only(
                      topLeft:
                          Radius.circular(34),
                      topRight:
                          Radius.circular(34),
                    ),
                  ),

                  child:
                      SingleChildScrollView(
                    controller:
                        scrollController,

                    padding:
                        const EdgeInsets.all(
                      20,
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        /// LOGO
                        Container(
                          width:
                              double.infinity,
                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 18,
                          ),

                          decoration:
                              BoxDecoration(
                            color: const Color(
                              0xffEEF4FF,
                            ),

                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),

                            border: Border.all(
                              color:
                                  const Color(
                                0xffD6E4FF,
                              ),
                            ),
                          ),

                          child: Center(
                            child: Image.asset(
                              'assets/images/islamic_center.png',
                              width: 70,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 22,
                        ),

                        /// TITLE
                        const Text(
                          'Tentang Islamic Center',

                          style: TextStyle(
                            fontSize: 24,
                            fontWeight:
                                FontWeight
                                    .w700,
                            color:
                                Color(
                              0xff1D1D1D,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Text(
                          'Islamic Centre Jawa Timur merupakan pusat pembinaan ulama, seniman, para pemuda, dan anak-anak di Jawa Timur.',

                          style: TextStyle(
                            fontSize: 14,
                            color: Colors
                                .grey
                                .shade700,

                            height: 1.7,
                          ),
                        ),

                        const SizedBox(
                          height: 22,
                        ),

                        /// MENU TAB
                        Container(
                          padding:
                              const EdgeInsets
                                  .all(4),

                          decoration:
                              BoxDecoration(
                            color:
                                Colors.white,

                            borderRadius:
                                BorderRadius.circular(
                              30,
                            ),

                            border: Border.all(
                              color: Colors
                                  .grey
                                  .shade300,
                            ),
                          ),

                          child: Row(
                            children: [

                              /// LAYANAN
                              Expanded(
                                child: InkWell(
                                  onTap: () {

                                    Navigator.pushReplacement(
                                      context,

                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                const IslamicCenterHomeScreen(),
                                      ),
                                    );
                                  },

                                  child: _buildMenuItem(
                                    'Layanan',
                                    false,
                                  ),
                                ),
                              ),

                              /// OPERASIONAL
                              Expanded(
                                child:
                                    _buildMenuItem(
                                  'Operasional',
                                  true,
                                ),
                              ),

                              /// KETENTUAN
                              Expanded(
                                child: InkWell(
                                  onTap: () {

                                    Scrollable
                                        .ensureVisible(
                                      ketentuanKey
                                          .currentContext!,

                                      duration:
                                          const Duration(
                                        milliseconds:
                                            400,
                                      ),

                                      curve:
                                          Curves
                                              .easeInOut,
                                    );
                                  },

                                  child: _buildMenuItem(
                                    'Ketentuan Umum',
                                    false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 28,
                        ),

                        /// OPERASIONAL
                        const Text(
                          'Operasional',

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        _buildInfoCard(
                          'Link Layanan',
                          'https://islamiccenter.jatimprov.go.id/',
                          isLink: true,
                        ),

                        _buildInfoCard(
                          'Alamat',
                          'Jl. Raya Dukuh Kupang No.122-124, Kec. Dukuhpakis, Surabaya',
                        ),

                        _buildInfoCard(
                          'Jam Operasional',
                          'Senin - Minggu (24 Jam)',
                        ),

                        _buildSocialCard(),

                        const SizedBox(
                          height: 30,
                        ),

                        /// KETENTUAN
                        Container(
                          key: ketentuanKey,

                          child: const Text(
                            'Ketentuan Umum',

                            style: TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight
                                      .w700,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        /// MANFAAT
                        _buildExpandTile(
                          title: 'Manfaat',
                          isExpanded:
                              manfaatExpand,

                          onTap: () {

                            setState(() {
                              manfaatExpand =
                                  !manfaatExpand;
                            });
                          },

                          content: Text(
                            'Kemudahan pemesanan fasilitas Islamic Centre Surabaya secara online, memungkinkan perencanaan acara Islami kapan pun dan di mana pun, dengan kenyamanan dan kualitas terbaik.',

                            style: TextStyle(
                              color: Colors
                                  .grey
                                  .shade700,

                              height: 1.7,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 16,
                        ),

                        /// SISTEM
                        _buildExpandTile(
                          title:
                              'Sistem, Mekanisme, dan Prosedur',

                          isExpanded:
                              sistemExpand,

                          onTap: () {

                            setState(() {
                              sistemExpand =
                                  !sistemExpand;
                            });
                          },

                          content: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(
                                'Platform pemesanan digital fasilitas Islamic Centre yang menyediakan informasi terkait fasilitas yang tersedia, harga, serta jadwal penggunaan.',

                                style: TextStyle(
                                  color: Colors
                                      .grey
                                      .shade700,

                                  height: 1.7,
                                ),
                              ),

                              const SizedBox(
                                height: 18,
                              ),

                              _buildNumberText(
                                1,
                                'Akses situs web Islamic Center Jawa Timur.',
                              ),

                              _buildNumberText(
                                2,
                                'Telusuri informasi fasilitas seperti aula, asrama, ruang pelatihan, dan lainnya.',
                              ),

                              _buildNumberText(
                                3,
                                'Pilih menu Pemesanan Fasilitas yang diinginkan.',
                              ),

                              _buildNumberText(
                                4,
                                'Isi formulir pemesanan online dengan data lengkap dan sesuai kebutuhan.',
                              ),

                              _buildNumberText(
                                5,
                                'Lakukan pembayaran sesuai ketentuan yang berlaku.',
                              ),

                              _buildNumberText(
                                6,
                                'Pemesanan selesai dan siap digunakan sesuai jadwal yang telah ditentukan.',
                              ),

                              _buildNumberText(
                                7,
                                'Hubungi pihak terkait apabila terdapat kendala.',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 40,
                        ),
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
      padding:
          const EdgeInsets.fromLTRB(
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
                  fontWeight:
                      FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(width: 18),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    String title,
    bool active,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 10,
      ),

      decoration: BoxDecoration(
        color: active
            ? const Color(
                0xffE9F0FF,
              )
            : Colors.transparent,

        borderRadius:
            BorderRadius.circular(30),
      ),

      child: Text(
        title,

        textAlign: TextAlign.center,

        style: TextStyle(
          fontSize: 12,

          fontWeight: FontWeight.w500,

          color: active
              ? const Color(
                  0xff2F61E8,
                )
              : Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value, {
    bool isLink = false,
  }) {
    return Container(
      width: double.infinity,

      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            title,

            style: const TextStyle(
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,

            style: TextStyle(
              color: isLink
                  ? const Color(
                      0xff2F61E8,
                    )
                  : Colors.grey.shade700,

              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialCard() {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(
            'Media Sosial',

            style: TextStyle(
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              _buildSocialItem(
                Icons.camera_alt,
                'Instagram',
              ),

              const SizedBox(width: 20),

              _buildSocialItem(
                Icons.play_circle_fill,
                'Youtube',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialItem(
    IconData icon,
    String title,
  ) {
    return Row(
      children: [

        Icon(
          icon,
          color:
              const Color(0xff2F61E8),
          size: 18,
        ),

        const SizedBox(width: 6),

        Text(
          title,

          style: const TextStyle(
            color:
                Color(0xff2F61E8),
          ),
        ),
      ],
    );
  }

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
            ? const Color(
                0xffF3F3F3,
              )
            : Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Column(
        children: [

          InkWell(
            onTap: onTap,

            child: Padding(
              padding:
                  const EdgeInsets.all(
                18,
              ),

              child: Row(
                children: [

                  Expanded(
                    child: Text(
                      title,

                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight
                                .w600,

                        fontSize: 15,
                      ),
                    ),
                  ),

                  Icon(
                    isExpanded
                        ? Icons.remove
                        : Icons.add,
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            duration: const Duration(
              milliseconds: 250,
            ),

            crossFadeState:
                isExpanded
                    ? CrossFadeState
                        .showFirst
                    : CrossFadeState
                        .showSecond,

            firstChild: Padding(
              padding:
                  const EdgeInsets
                      .fromLTRB(
                18,
                0,
                18,
                18,
              ),

              child: content,
            ),

            secondChild:
                const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberText(
    int number,
    String text,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            '$number. ',

            style: TextStyle(
              color: Colors
                  .grey
                  .shade700,

              height: 1.7,
            ),
          ),

          Expanded(
            child: Text(
              text,

              style: TextStyle(
                color: Colors
                    .grey
                    .shade700,

                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}