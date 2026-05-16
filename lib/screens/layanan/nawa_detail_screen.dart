import 'package:flutter/material.dart';
import '../service_model.dart';

class NawaDetailScreen
    extends StatelessWidget {

  final String title;
  final String description;
  final String image;

  const NawaDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {

    final filteredData =
        recommendations.where(
      (item) =>
          item.nawaBhakti == title,
    ).toList();

    return Scaffold(
      backgroundColor:
          const Color(0xFF0D57E7),

      body: SafeArea(
        bottom: false,

        child: Stack(
          children: [

            /// BACKGROUND
            Container(
              width: double.infinity,
              height: 300,

              decoration:
                  const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/latar_belakang.png",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Column(
              children: [

                /// HEADER
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(
                    24,
                    30,
                    24,
                    20,
                  ),

                  child: Row(
                    children: [

                      GestureDetector(
                        onTap: () {
                          Navigator.pop(
                            context,
                          );
                        },

                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Text(
                          title,

                          textAlign:
                              TextAlign.center,

                          style:
                              const TextStyle(
                            color:
                                Colors.white,

                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                ),

                /// BODY PUTIH
                Expanded(
                  child: Container(
                    width: double.infinity,

                    padding:
                        const EdgeInsets.all(
                      20,
                    ),

                    decoration:
                        const BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.only(
                        topLeft:
                            Radius.circular(
                          35,
                        ),

                        topRight:
                            Radius.circular(
                          35,
                        ),
                      ),
                    ),

                    child: Column(
                      children: [

                        /// IMAGE
                        Container(
                          width: 100,
                          height: 100,

                          padding:
                              const EdgeInsets
                                  .all(14),

                          decoration:
                              const BoxDecoration(
                            color:
                                Color(0xffF5F7FF),

                            shape:
                                BoxShape.circle,
                          ),

                          child: Image.asset(
                            image,
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        /// DESCRIPTION
                        Text(
                          description,

                          textAlign:
                              TextAlign.center,

                          style:
                              TextStyle(
                            fontSize: 16,
                            height: 1.6,

                            color: Colors
                                .grey
                                .shade700,
                          ),
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        /// GRID
                        Expanded(
                          child:
                              GridView.builder(
                            itemCount:
                                filteredData
                                    .length,

                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  2,

                              crossAxisSpacing:
                                  14,

                              mainAxisSpacing:
                                  14,

                              childAspectRatio:
                                  0.82,
                            ),

                            itemBuilder:
                                (context,
                                    index) {

                              final item =
                                  filteredData[
                                      index];

                              return GestureDetector(
                                onTap: () {

                                  debugPrint(
                                    "${item.title} ditekan",
                                  );

                                  if (item.screen !=
                                      null) {

                                    Navigator.push(
                                      context,

                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                item.screen!,
                                      ),
                                    );
                                  }
                                },

                                child:
                                    Container(
                                  padding:
                                      const EdgeInsets
                                          .all(16),

                                  decoration:
                                      BoxDecoration(
                                    color: Colors
                                        .white,

                                    borderRadius:
                                        BorderRadius.circular(
                                      22,
                                    ),

                                    border:
                                        Border.all(
                                      color:
                                          const Color(
                                        0xffEAEAEA,
                                      ),
                                    ),
                                  ),

                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [

                                      Container(
                                        width:
                                            58,
                                        height:
                                            58,

                                        padding:
                                            const EdgeInsets.all(
                                          10,
                                        ),

                                        decoration:
                                            const BoxDecoration(
                                          color:
                                              Color(
                                            0xffF5F7FF,
                                          ),

                                          shape:
                                              BoxShape.circle,
                                        ),

                                        child:
                                            Image.asset(
                                          "assets/images/${item.logo}",
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                            16,
                                      ),

                                      Text(
                                        item
                                            .title,

                                        maxLines:
                                            2,

                                        overflow:
                                            TextOverflow.ellipsis,

                                        style:
                                            const TextStyle(
                                          fontSize:
                                              16,

                                          fontWeight:
                                              FontWeight.w700,

                                          height:
                                              1.4,
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                            10,
                                      ),

                                      Text(
                                        item
                                            .description,

                                        maxLines:
                                            3,

                                        overflow:
                                            TextOverflow.ellipsis,

                                        style:
                                            TextStyle(
                                          fontSize:
                                              13,

                                          height:
                                              1.5,

                                          color: Colors
                                              .grey
                                              .shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}