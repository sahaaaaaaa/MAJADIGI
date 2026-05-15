import 'package:flutter/material.dart';
import 'islamic_center_dummy.dart';
import 'islamic_center_detail_fasilitas.dart';
import 'islamic_center_info_screen.dart';

class IslamicCenterHomeScreen extends StatefulWidget {
  const IslamicCenterHomeScreen({super.key});

  @override
  State<IslamicCenterHomeScreen> createState() =>
      _IslamicCenterHomeScreenState();
}

class _IslamicCenterHomeScreenState
    extends State<IslamicCenterHomeScreen> {

  TextEditingController searchController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    final filteredFasilitas =
        IslamicCenterDummy.fasilitas.where((item) {

      return item.title
          .toLowerCase()
          .contains(
            searchController.text
                .toLowerCase(),
          );
    }).toList();

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

                        /// SEARCH
                        TextFormField(
                          controller:
                              searchController,

                          onChanged: (value) {
                            setState(() {});
                          },

                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,

                            hintText: 'Cari Gedung',

                            hintStyle: const TextStyle(
                              fontSize: 14,
                              color: Color(
                                0xFFA0A0A0,
                              ),
                            ),

                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(
                                0xFFA0A0A0,
                              ),
                            ),

                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),

                            enabledBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),

                              borderSide:
                                  BorderSide(
                                color: Colors
                                    .grey.shade300,
                              ),
                            ),

                            focusedBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                14,
                              ),

                              borderSide:
                                  const BorderSide(
                                color: Color(
                                  0xff1E4FD8,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 26),

                        /// TITLE
                        const Text(
                          'Fasilitas Gedung',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.w700,
                            color:
                                Color(0xff1D1D1D),
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// LIST
                        ListView.builder(
                          shrinkWrap: true,

                          physics:
                              const NeverScrollableScrollPhysics(),

                          itemCount:
                              filteredFasilitas
                                  .length,

                          itemBuilder:
                              (context, index) {

                            final item =
                                filteredFasilitas[
                                    index];

                            return _buildFacilityCard(
                              item,
                            );
                          },
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
                'Islamic Center',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          Row(
            children: [

              IconButton(
                onPressed: () {},

                icon: const Icon(
                  Icons.bookmark_border,
                  color: Colors.white,
                ),
              ),

              InkWell(
                onTap: () {

                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          const IslamicCenterInfoScreen(),
                    ),
                  );
                },

                child: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// FACILITY CARD
  Widget _buildFacilityCard(
    IslamicCenterFacilityModel item,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 18,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          /// IMAGE
          ClipRRect(
            borderRadius:
                const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),

            child: Image.asset(
              item.image,
              width: double.infinity,
              height: 210,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                /// TITLE
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                /// DESC
                Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 14),

                /// TAGS
                Wrap(
                  spacing: 8,
                  runSpacing: 8,

                  children:
                      item.tags.map((tag) {

                    return Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(
                          0xffEEF3FF,
                        ),

                        borderRadius:
                            BorderRadius.circular(
                          8,
                        ),
                      ),

                      child: Text(
                        tag,
                        style: const TextStyle(
                          color:
                              Color(0xff1E4FD8),
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 18),

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 46,

                  child: OutlinedButton(
                    onPressed: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              IslamicCenterDetailFasilitas(
                            facility: item,
                          ),
                        ),
                      );
                    },

                    style:
                        OutlinedButton.styleFrom(
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),
                      ),

                      side: BorderSide(
                        color:
                            Colors.grey.shade300,
                      ),
                    ),

                    child: const Text(
                      'Lihat Detail',
                      style: TextStyle(
                        color:
                            Color(0xff1D1D1D),
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
}