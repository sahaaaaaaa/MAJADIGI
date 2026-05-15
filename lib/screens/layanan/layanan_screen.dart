import 'package:flutter/material.dart';
import 'package:majadigi/screens/beranda/layanan_lain.dart';
import '../service_model.dart';

class LayananScreen extends StatefulWidget {
  const LayananScreen({super.key});

  @override
  State<LayananScreen> createState() =>
      _LayananScreenState();
}

class _LayananScreenState
  extends State<LayananScreen> {
    final TextEditingController
    searchController =
        TextEditingController();

  String searchQuery = '';

  int selectedTab = 0;

  final List<String> tabs = [
    "Layanan",
    "Nawa Bhakti Satya",
    "Katalog",
  ];

  final List<Map<String, dynamic>>
      kategoriList = [
        
    {
      "title":
          "Pariwisata & Kebudayaan",
      "image":
          "assets/images/kategori/pariwisata_&_kebudayaan.png",
    },

    {
      "title": "Pendidikan",
      "image":
          "assets/images/kategori/pendidikan.png",
    },

    {
      "title": "Ketenagakerjaan",
      "image":
          "assets/images/kategori/ketenagakerjaan.png",
    },

    {
      "title": "Ekonomi & Bisnis",
      "image":
          "assets/images/kategori/ekonomi_&_bisnis.png",
    },

    {
      "title": "Kesehatan",
      "image":
          "assets/images/kategori/kesehatan.png",
    },

    {
      "title": "Kependudukan",
      "image":
          "assets/images/kategori/kependudukan.png",
    },

    {
      "title":
          "Multisektor (Khusus)",
      "image":
          "assets/images/kategori/multisektor.png",
    },

    {
      "title": "Infrastruktur",
      "image":
          "assets/images/kategori/infrastuktur.png",
    },
    
  ];

  List<Recommendation>
    get filteredRecommendations {

  return recommendations
      .where(
        (item) => item.title
            .toString()
            .toLowerCase()
            .contains(
              searchQuery
                  .toLowerCase(),
            ),
      )
      .toList();
}

  @override

  void showSearchDialog() {

  showModalBottomSheet(
    context: context,

    isScrollControlled: true,

    backgroundColor: Colors.white,

    shape:
        const RoundedRectangleBorder(
      borderRadius:
          BorderRadius.vertical(
        top: Radius.circular(30),
      ),
    ),

    builder: (context) {

      return StatefulBuilder(
        builder:
            (context, setModalState) {

          return Padding(
            padding:
                EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,

              bottom:
                  MediaQuery.of(
                context,
              ).viewInsets.bottom +
                      24,
            ),

            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [

                TextField(
                  controller:
                      searchController,

                  onChanged: (value) {

                    setModalState(() {
                      searchQuery =
                          value;
                    });
                  },

                  decoration:
                      InputDecoration(
                    hintText:
                        'Cari layanan...',

                    prefixIcon:
                        const Icon(
                      Icons.search,
                    ),

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                if (filteredRecommendations
                    .isEmpty)

                  const Padding(
                    padding:
                        EdgeInsets.all(
                      20,
                    ),

                    child: Text(
                      "Layanan tidak ditemukan",
                    ),
                  ),

                if (filteredRecommendations
                    .isNotEmpty)

                  SizedBox(
                    height: 300,

                    child: ListView.builder(
                      itemCount:
                          filteredRecommendations
                              .length,

                      itemBuilder:
                          (context, index) {

                        final item =
                            filteredRecommendations[
                                index];

                        return ListTile(
                          leading:
                              CircleAvatar(
                            backgroundColor:
                                const Color(
                              0xffF5F7FF,
                            ),

                            child:
                                Image.asset(
                              "assets/images/${item.logo}",
                            ),
                          ),

                          title:
                              Text(
                            item.title,
                          ),

                          subtitle:
                              Text(
                            item.kategori,
                          ),

                          onTap: () {

                            Navigator.pop(
                              context,
                            );

                            if (item.screen !=
                                null) {

                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) =>
                                      item.screen!,
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      );
    },
  );
}

  Widget build(BuildContext context) {

    return Scaffold(
  backgroundColor: const Color(0xFF0D57E7),

  body: SafeArea(
    bottom: false,

    child: Stack(
      children: [

        /// BACKGROUND IMAGE
        Container(
          width: double.infinity,
          height: 300,

          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/images/latar_belakang.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),

        /// CONTENT
        Column(
          children: [

            /// HEADER
            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                30,
                24,
                20,
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  const Text(
                    "Semua Layanan",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      showSearchDialog();
                    },

                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),

            /// BODY PUTIH
            Expanded(
              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.all(16),

                decoration: const BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),

                child: Column(
                  children: [

                    /// TAB
                    Container(
                      padding: const EdgeInsets.all(4),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius:
                            BorderRadius.circular(30),

                        border: Border.all(
                          color: const Color(
                            0xffE5E5E5,
                          ),
                        ),
                      ),

                      child: Row(
                        children: List.generate(
                          tabs.length,
                          (index) {

                            final isActive =
                                selectedTab == index;

                            return Expanded(
                              child: GestureDetector(
                                onTap: () {

                                  setState(() {
                                    selectedTab =
                                        index;
                                  });
                                },

                                child:
                                    AnimatedContainer(
                                  duration:
                                      const Duration(
                                    milliseconds: 250,
                                  ),

                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    vertical: 12,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color: isActive
                                        ? const Color(
                                            0xffE9F0FF,
                                          )
                                        : Colors
                                            .transparent,

                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      24,
                                    ),
                                  ),

                                  child: Center(
                                    child: Text(
                                      tabs[index],

                                      style: TextStyle(
                                        fontSize: 13,

                                        fontWeight:
                                            isActive
                                                ? FontWeight
                                                    .w600
                                                : FontWeight
                                                    .w400,

                                        color: isActive
                                            ? const Color(
                                                0xff2F61E8,
                                              )
                                            : Colors
                                                .grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// GRID
                    Expanded(
                      child: GridView.builder(
                        itemCount:
                            kategoriList.length,

                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.82,
                        ),

                        itemBuilder:
                            (context, index) {

                          final item =
                              kategoriList[index];

                          return GestureDetector(
                            onTap: () {

                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) =>
                                      LayananLainScreen(
                                    kategori:
                                        item["title"],
                                  ),
                                ),
                              );
                            },

                            child: Container(
                              padding:
                                  const EdgeInsets
                                      .all(16),

                              decoration:
                                  BoxDecoration(
                                color: Colors.white,

                                borderRadius:
                                    BorderRadius
                                        .circular(22),

                                border: Border.all(
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
                                    width: 58,
                                    height: 58,

                                    padding:
                                        const EdgeInsets
                                            .all(10),

                                    decoration:
                                        BoxDecoration(
                                      color:
                                          const Color(
                                        0xffF5F7FF,
                                      ),

                                      shape: BoxShape
                                          .circle,
                                    ),

                                    child:
                                        Image.asset(
                                      item["image"],
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 16,
                                  ),

                                  Text(
                                    item["title"],

                                    maxLines: 2,

                                    overflow:
                                        TextOverflow
                                            .ellipsis,

                                    style:
                                        const TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight
                                              .w700,
                                      height: 1.4,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Text(
                                    "Koleksi khas semua tentang Jawa Timur",

                                    maxLines: 3,

                                    overflow:
                                        TextOverflow
                                            .ellipsis,

                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.5,

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