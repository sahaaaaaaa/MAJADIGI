import 'package:flutter/material.dart';
import 'point_jatim_dummy.dart';
import 'point_jatim_info_screen.dart';
import 'layanan_detail_screen.dart';

class PointJatimHomeScreen extends StatefulWidget {
  const PointJatimHomeScreen({super.key});

  @override
  State<PointJatimHomeScreen> createState() =>
      _PointJatimHomeScreenState();
}

class _PointJatimHomeScreenState extends State<PointJatimHomeScreen> {
  @override
  String selectedKategori = 'Semua';

  TextEditingController searchController =
      TextEditingController();

  Widget build(BuildContext context) {
    final filteredProjects =
        PointJatimDummy.projects.where((item) {
      final matchKategori =
          selectedKategori == 'Semua'
              ? true
              : item.category == selectedKategori;

      final matchSearch = item.title
          .toLowerCase()
          .contains(
            searchController.text.toLowerCase(),
          );

      return matchKategori && matchSearch;
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

            /// HEADER
            _buildHeader(context),

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
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 30,
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      /// SEARCH
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),

                        child: TextFormField(
                          controller: searchController,

                          onChanged: (value) {
                            setState(() {});
                          },

                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF2F2F2F),
                            fontFamily: 'Onest',
                          ),

                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,

                            hintText: 'Cari Data',

                            hintStyle: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFFA0A0A0),
                              fontFamily: 'Onest',
                              fontWeight: FontWeight.w400,
                            ),

                            prefixIcon: const Padding(
                              padding: EdgeInsets.only(
                                left: 11,
                                right: 1,
                              ),

                              child: Icon(
                                Icons.search,
                                color: Color(0xFFA0A0A0),
                                size: 30,
                              ),
                            ),

                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(18),

                              borderSide: const BorderSide(
                                color: Color(0xFFE2E2E2),
                                width: 1.2,
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(18),

                              borderSide: const BorderSide(
                                color: Color(0xFF0E63FF),
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// KATEGORI
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _showFilterSheet();
                          },
                          child: Container(
                            height: 55,
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 14,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(14),
                              border: Border.all(
                                color:
                                    Colors.grey.shade300,
                              ),
                            ),

                            child: Row(
                              children: [

                                Icon(
                                  Icons.grid_view_rounded,
                                  color:
                                      Colors.grey.shade400,
                                  size: 20,
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Text(
                                    'Kategori',
                                    style: TextStyle(
                                      color: Colors
                                          .grey.shade500,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                Icon(
                                  Icons
                                      .keyboard_arrow_down_rounded,
                                  color:
                                      Colors.grey.shade400,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      /// PROJECT TERBARU
                      Container(
                        width: double.infinity,
                        color: const Color(0xff2F61E8),
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 20,
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(
                                horizontal: 16,
                              ),

                              child: Text(
                                'Project Terbaru',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w700,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            SizedBox(
                              height: 225,

                              child: ListView.separated(
                                scrollDirection:
                                    Axis.horizontal,

                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 16,
                                ),

                                itemBuilder:
                                    (context, index) {

                                  final item =
                                      PointJatimDummy
                                              .highlights[
                                          index];

                                  return _buildHighlightCard(
                                    item,
                                  );
                                },

                                separatorBuilder:
                                    (_, __) =>
                                        const SizedBox(
                                  width: 14,
                                ),

                                itemCount:
                                    PointJatimDummy
                                        .highlights
                                        .length,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// TITLE
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(
                          horizontal: 16,
                        ),

                        child: Text(
                          'List Project Ready to Offer',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.w700,
                            color: Color(0xff1D1D1D),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      /// PROJECT LIST
                      ListView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),

                        itemCount:
                            filteredProjects.length,

                        itemBuilder: (context, index) {

                          final item =
                              filteredProjects[index];

                          return _buildProjectCard(
                            context,
                            item,
                          );
                        },
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

  Widget _buildHeader(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(
      16,
      55,
      16,
      0,
    ),

    child: Row(
      children: [

        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },

          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),

        const Expanded(
          child: Center(
            child: Text(
              'POINT JATIM',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
        ),

        Row(
          children: [

            const Icon(
              Icons.bookmark_border_rounded,
              color: Colors.white,
            ),

            const SizedBox(width: 12),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const PointJatimInfoScreen(),
                  ),
                );
              },

              child: const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  Widget _buildHighlightCard(
    PointJatimHighlightModel item,
  ) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
            child: Image.asset(
              item.image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(
    BuildContext context,
    PointJatimProjectModel item,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LayananDetailScreen(
              item: item,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: Image.asset(
                item.image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xff2F61E8),
                      ),
                    ),
                    child: Text(
                      item.category,
                      style: const TextStyle(
                        color: Color(0xff2F61E8),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    item.harga,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xff2F61E8),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.lokasi,
                          style: const TextStyle(
                            color: Color(0xff2F61E8),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Text(
                        item.tahun,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                        ),
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
  
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),

      builder: (context) {

        String tempKategori = selectedKategori;

        return StatefulBuilder(
          builder: (context, setModalState) {

            return Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                24,
                24,
                30,
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Kategori',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: tempKategori,

                    dropdownColor: Colors.white,

                    style: const TextStyle(
                      color: Color(0xff1D1D1D),
                      fontSize: 16,
                    ),

                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xff666666),
                    ),

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,

                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),

                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(18),

                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(18),

                        borderSide: const BorderSide(
                          color: Color(0xff2F61E8),
                        ),
                      ),
                    ),

                    items: PointJatimDummy
                        .kategoriList
                        .map((item) {

                      return DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),

                    onChanged: (value) {
                      setModalState(() {
                        tempKategori = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [

                      Expanded(
                        child: SizedBox(
                          height: 52,

                        child: OutlinedButton(
                          onPressed: () {

                            setState(() {
                              selectedKategori =
                                  'Semua';
                            });

                            Navigator.pop(context);
                          },

                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xff2F61E8),

                            side: const BorderSide(
                              color: Color(0xff2F61E8),
                            ),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),

                          child: const Text(
                            'Reset',
                          ),
                        ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: SizedBox(
                          height: 52,
                          
                          child: ElevatedButton(
                            onPressed: () {

                              setState(() {
                                selectedKategori =
                                    tempKategori;
                              });

                              Navigator.pop(context);
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff2F61E8),
                              foregroundColor: Colors.white,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),

                            child: const Text(
                              'Terapkan',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}