import 'package:flutter/material.dart';

class KatalogScreen extends StatelessWidget {
  const KatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, String>> katalogList = [

      {
        "title": "Paket Kunjungan Agrowisata",

        "description":
            "Koleksi khas semua tentang Jawa Timur",

        "image":
            "assets/images/klinik_hoax.png",
      },

      {
        "title": "Khas Jatim",

        "description":
            "Koleksi khas semua tentang Jawa Timur",

        "image":
            "assets/images/khas_jatim.png",
      },

      {
        "title": "Cak Durasim",

        "description":
            "Koleksi khas semua tentang Jawa Timur",

        "image":
            "assets/images/cak_durasim.png",
      },

      {
        "title": "East Java Virtual Tour",

        "description":
            "Koleksi khas semua tentang Jawa Timur",

        "image":
            "assets/images/klinik_hoax.png",      
            },

      {
        "title": "SKOPI",

        "description":
            "Koleksi khas semua tentang Jawa Timur",

        "image":
            "assets/images/SKOPI.png",
      },

      {
        "title": "Kidungan",

        "description":
            "Koleksi khas semua tentang Jawa Timur",

        "image":
            "assets/images/kidungan.jpg",
      },

      {
        "title": "Nganjuk Smart City",

        "description":
            "Koleksi khas semua tentang Jawa Timur",

        "image":
            "assets/images/nganjuk_smartcity.png",
      },

      {
        "title": "Pusaka Jatim",

        "description":
            "Koleksi khas semua tentang Jawa Timur",

        "image":
            "assets/images/klinik_hoax.png",
      },
    ];

    return ListView.separated(
      physics:
          const BouncingScrollPhysics(),

      itemCount: katalogList.length,

      separatorBuilder:
          (context, index) {

        return const SizedBox(
          height: 16,
        );
      },

      itemBuilder: (context, index) {

        final item = katalogList[index];

        return GestureDetector(
          onTap: () {

            debugPrint(
              "${item["title"]} ditekan",
            );
          },

          child: Container(
            padding:
                const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius:
                  BorderRadius.circular(
                22,
              ),

              border: Border.all(
                color: const Color(
                  0xffEAEAEA,
                ),
              ),
            ),

            child: Row(
              children: [

                /// IMAGE
                Container(
                  width: 58,
                  height: 58,

                  padding:
                      const EdgeInsets.all(
                    10,
                  ),

                  decoration:
                      const BoxDecoration(
                    color:
                        Color(0xffF5F7FF),

                    shape:
                        BoxShape.circle,
                  ),

                  child: Image.asset(
                    item["image"]!,
                  ),
                ),

                const SizedBox(width: 18),

                /// NUMBER
                Text(
                  "${index + 1}",

                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(width: 20),

                /// TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Text(
                        item["title"]!,

                        maxLines: 1,

                        overflow:
                            TextOverflow
                                .ellipsis,

                        style:
                            const TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Text(
                        item["description"]!,

                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,

                          color: Colors
                              .grey
                              .shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}