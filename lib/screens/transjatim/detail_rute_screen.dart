import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailRuteScreen
    extends StatefulWidget {
  final String code;
  final String from;
  final String to;
  final String time;

  const DetailRuteScreen({
    super.key,
    required this.code,
    required this.from,
    required this.to,
    required this.time,
  });

  @override
  State<DetailRuteScreen>
      createState() =>
          _DetailRuteScreenState();
}

class _DetailRuteScreenState
    extends State<
        DetailRuteScreen> {
  int selectedHalte = 0;

  final List<String> haltes = [
    "Halte Terminal Porong",
    "Halte Gedang",
    "Halte Tanggulangin",
    "Halte Keramean",
    "Halte Terminal Larangan",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent,

      body: Stack(
        children: [
          // HEADER BG
          Container(
            width: double.infinity,
            height: 230,
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

                      Expanded(
                        child: Text(
                          widget.code,
                          textAlign:
                              TextAlign.center,
                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                            fontSize: 22,
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

                Expanded(
                  child:
                      SingleChildScrollView(
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
                            const EdgeInsets.all(
                          16,
                        ),

                        child: Column(
                          children: [
                            // MAPS
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),

                              child: Stack(
                                children: [
                                  Image.asset(
                                    'assets/images/maps_transjatim.png',
                                    width: double
                                        .infinity,
                                    height: 380,
                                    fit: BoxFit
                                        .cover,
                                  ),

                                  // LABEL HALTE
                                  if (selectedHalte !=
                                      -1)
                                    Positioned(
                                      top: 120,
                                      left: 70,

                                      child:
                                          Container(
                                        padding:
                                            const EdgeInsets.symmetric(
                                          horizontal:
                                              18,
                                          vertical:
                                              14,
                                        ),

                                        decoration:
                                            BoxDecoration(
                                          color:
                                              Colors.white,

                                          borderRadius:
                                              BorderRadius.circular(
                                            18,
                                          ),
                                        ),

                                        child:
                                            Text(
                                          haltes[
                                              selectedHalte],
                                          style:
                                              const TextStyle(
                                            fontSize:
                                                16,
                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // JAM
                            Container(
                              width:
                                  double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal:
                                    16,
                                vertical:
                                    14,
                              ),

                              decoration:
                                  const BoxDecoration(
                                color: Color(
                                  0xFF27AE60,
                                ),

                                borderRadius:
                                    BorderRadius.vertical(
                                  bottom:
                                      Radius.circular(
                                    20,
                                  ),
                                ),
                              ),

                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icons/clock_white.svg',
                                    width:
                                        18,
                                  ),

                                  const SizedBox(
                                      width:
                                          10),

                                  Text(
                                    "Jam Operasional ${widget.time}",
                                    style:
                                        const TextStyle(
                                      color: Colors
                                          .white,
                                      fontSize:
                                          16,
                                      fontWeight:
                                          FontWeight
                                              .w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                                height: 18),

                            // DARI KE
                            Container(
                              padding:
                                  const EdgeInsets.all(
                                16,
                              ),

                              decoration:
                                  BoxDecoration(
                                color: Colors
                                    .white,

                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),

                                border:
                                    Border.all(
                                  color: Colors
                                      .grey
                                      .shade300,
                                ),
                              ),

                              child: Column(
                                children: [
                                  _routeField(
                                    label:
                                        "Dari",
                                    value:
                                        widget
                                            .from,
                                    icon:
                                        'assets/images/icons/marker-pin-02.svg',
                                  ),

                                  const SizedBox(
                                      height:
                                          14),

                                  Stack(
                                    clipBehavior:
                                        Clip.none,

                                    children: [
                                      _routeField(
                                        label:
                                            "Ke",
                                        value:
                                            widget
                                                .to,
                                        icon:
                                            'assets/images/icons/marker-pin-02.svg',
                                      ),

                                      Positioned(
                                        right:
                                            -5,
                                        top:
                                            -15,

                                        child:
                                            Container(
                                          width:
                                              48,
                                          height:
                                              48,

                                          decoration:
                                              BoxDecoration(
                                            color:
                                                Colors.white,

                                            shape:
                                                BoxShape.circle,

                                            border:
                                                Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),

                                          child:
                                              Center(
                                            child:
                                                SvgPicture.asset(
                                              'assets/images/icons/switch-vertical-01.svg',
                                              width: 22,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                                height: 18),

                            // HALTE LIST
                            Container(
                              width:
                                  double.infinity,
                              padding:
                                  const EdgeInsets.all(
                                16,
                              ),

                              decoration:
                                  BoxDecoration(
                                color: Colors
                                    .white,

                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),

                                border:
                                    Border.all(
                                  color: Colors
                                      .grey
                                      .shade300,
                                ),
                              ),

                              child: Column(
                                children:
                                    List.generate(
                                  haltes.length,
                                  (index) {
                                    final isActive =
                                        selectedHalte ==
                                            index;

                                    return GestureDetector(
                                      onTap:
                                          () {
                                        setState(
                                          () {
                                            selectedHalte =
                                                index;
                                          },
                                        );
                                      },

                                      child:
                                          Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,

                                        children: [
                                          Column(
                                            children: [
                                              SvgPicture.asset(
                                                isActive
                                                    ? 'assets/images/icons/marker-pin-green.svg'
                                                    : 'assets/images/icons/ellipse2.svg',

                                                width:
                                                    14,
                                              ),

                                              if (index !=
                                                  haltes.length -
                                                      1)
                                                Container(
                                                  width:
                                                      2,
                                                  height:
                                                      38,
                                                  color:
                                                      const Color(
                                                    0xFFD9D9D9,
                                                  ),
                                                ),
                                            ],
                                          ),

                                          const SizedBox(
                                              width:
                                                  14),

                                          Expanded(
                                            child:
                                                Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                top:
                                                    0,
                                              ),

                                              child:
                                                  Text(
                                                haltes[
                                                    index],

                                                style:
                                                    TextStyle(
                                                  fontSize:
                                                      16,

                                                  fontWeight:
                                                      isActive
                                                          ? FontWeight.w600
                                                          : FontWeight.normal,

                                                  color:
                                                      isActive
                                                          ? const Color(
                                                            0xFF27AE60,
                                                          )
                                                          : Colors.grey.shade700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
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

  Widget _routeField({
    required String label,
    required String value,
    required String icon,
  }) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 22,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(
                    height: 4),

                Text(
                  value,
                  style:
                      const TextStyle(
                    fontSize: 17,
                    fontWeight:
                        FontWeight.w500,
                    color: Color(
                      0xFF121938,
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
}