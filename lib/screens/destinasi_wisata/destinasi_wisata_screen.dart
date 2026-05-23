import 'package:flutter/material.dart';
import 'detail_wisata_screen.dart';
import 'informasi_wisata.dart';

class DestinasiWisataScreen extends StatefulWidget {
  const DestinasiWisataScreen({super.key});

  @override
  State<DestinasiWisataScreen> createState() =>
      _DestinasiWisataScreenState();
}

class _DestinasiWisataScreenState
    extends State<DestinasiWisataScreen> {
  String lokasi = "Malang, Jawa Timur";

  Map<String, bool> kategori = {
    "Dataran Tinggi/Gunung": true,
    "Pantai/Laut": false,
    "Air Terjun": false,
    "Wisata Buatan & Taman Hiburan": false,
    "Wisata Kota, Budaya, Edukasi": false,
  };

  void _showKategori() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Kategori",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ...kategori.keys.map((key) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            Expanded(
                              child: Text(key),
                            ),

                            GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  kategori[key] =
                                      !(kategori[key] ??
                                          false);
                                });
                              },

                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: kategori[key]!
                                      ? const Color(
                                          0xFF0E63FF,
                                        )
                                      : Colors.transparent,

                                  borderRadius:
                                      BorderRadius.circular(
                                    6,
                                  ),

                                  border: Border.all(
                                    color: kategori[key]!
                                        ? const Color(
                                            0xFF0E63FF,
                                          )
                                        : Colors.grey,
                                  ),
                                ),

                                child: kategori[key]!
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color:
                                            Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                          ],
                        ),

                        const Divider(),
                      ],
                    );
                  }),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFE9EEF6),
                            borderRadius:
                                BorderRadius.circular(
                              30,
                            ),
                          ),

                          child: TextButton(
                            onPressed: () {
                              setModalState(() {
                                kategori.updateAll(
                                  (key, value) => false,
                                );
                              });
                            },

                            child: const Text(
                              "Reset",
                              style: TextStyle(
                                color:
                                    Color(0xFF0E63FF),
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF0E63FF),
                            borderRadius:
                                BorderRadius.circular(
                              30,
                            ),
                          ),

                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },

                            child: const Text(
                              "Terapkan",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      body: CustomScrollView(
        slivers: [

          // ================= HEADER =================
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor:
                const Color(0xFF0B57D0),
            expandedHeight: 170,
            toolbarHeight: 70,
            elevation: 0,

            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/latar_belakang.png",
                  ),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),

            titleSpacing: 0,

            title: Padding(
              padding:
                  const EdgeInsets.only(right: 16),

              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        "Destinasi Wisata",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.bookmark_border,
                    color: Colors.white,
                  ),

                  const SizedBox(width: 12),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const InformasiScreen(),
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
            ),

            bottom: PreferredSize(
              preferredSize:
                  const Size.fromHeight(90),

              child: Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  20,
                ),

                child: Container(
                  height: 58,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(22),
                  ),

                  child: TextField(
                    decoration: InputDecoration(
                      hintText:
                          "Malang, Jawa Timur",

                      prefixIcon: const Icon(
                        Icons
                            .location_on_outlined,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          22,
                        ),

                        borderSide:
                            BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ================= CONTENT =================
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                // KATEGORI
                Container(
  decoration: const BoxDecoration(
    image: DecorationImage(
      image: AssetImage(
        "assets/images/latar_belakang.png",
      ),
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    ),
  ),

                  child: Padding(
                   padding: const EdgeInsets.fromLTRB(
  16,
  10,
  16,
  20,
),

                    child: GestureDetector(
                      onTap: _showKategori,

                      child: Container(
                        padding:
                            const EdgeInsets.all(
                          16,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(
                            22,
                          ),
                        ),

                        child: const Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                          children: [
                            Row(
                              children: [
                                Icon(Icons
                                    .grid_view_outlined),

                                SizedBox(width: 10),

                                Text(
                                  "Kategori",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight
                                            .w500,
                                  ),
                                ),
                              ],
                            ),

                            Icon(Icons
                                .keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // CONTENT PUTIH
                Container(
                  color:
                      const Color(0xFFF5F5F5),

                  child: Padding(
                    padding:
                        const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        const Text(
                          "Wisata Populer di Malang",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 14),

                        SizedBox(
                          height: 230,

                          child: ListView(
                            scrollDirection:
                                Axis.horizontal,

                            children: [
                              _cardHorizontal(
                                "Gunung Bromo",
                                "Gunung Bromo adalah gunung berapi aktif...",
                                "assets/images/bromo.png",
                              ),

                              const SizedBox(
                                  width: 16),

                              _cardHorizontal(
                                "Kawah Ijen",
                                "Keindahan kawah ijen dengan fenomena...",
                                "assets/images/kawah_ijen.png",
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          "Semua Wisata",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        _cardVertical(
                          title: "Gunung Bromo",
                          desc:
                              "Gunung Bromo adalah gunung Berapi aktif di Jawa Timur, Indonesia.",
                          location:
                              "Kabupaten Probolinggo",
                          image:
                              "assets/images/bromo.png",
                        ),

                        _cardVertical(
                          title: "Kawah Ijen",
                          desc:
                              "Keindahan Kawah ijen dengan fenomena alam yang mendunia.",
                          location:
                              "Kabupaten Banyuwangi",
                          image:
                              "assets/images/kawah_ijen.png",
                        ),
                      ],
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


  // 🔥 HORIZONTAL CLICKABLE
  Widget _cardHorizontal(String title, String desc, String image) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DetailWisataScreen()),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                image,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 VERTICAL CLICKABLE
  Widget _cardVertical({
    required String title,
    required String desc,
    required String location,
    required String image,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DetailWisataScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    image,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.black26,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    desc,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Color(0xFF0E63FF),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(color: Color(0xFF0E63FF)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
