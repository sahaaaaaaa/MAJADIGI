import 'package:flutter/material.dart';
import 'package:majadigi/screens/open_data/open_data_dummy.dart';

class FiturDetailDataSetScreen extends StatefulWidget {

  final HighlightDataModel item;

  FiturDetailDataSetScreen({
    super.key,
    required this.item,
  });

  @override
  State<FiturDetailDataSetScreen> createState() => _FiturDetailDataSetScreenState();
}

class _FiturDetailDataSetScreenState extends State<FiturDetailDataSetScreen> {
  int currentPage  = 1;

  final int itemPerPage = 5;
  int get totalPage =>
    (dummyTableData.length / itemPerPage).ceil();

  List<DataTableModel> get paginatedData {
    final start = (currentPage - 1) * itemPerPage;
    final end = start + itemPerPage;
    if (start >= dummyTableData.length) {
      return [];
}
    return dummyTableData.sublist(
      start,
      end > dummyTableData.length
          ? dummyTableData.length
          : end,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF5F5F5),

      body: SingleChildScrollView(

        child: Column(
          children: [

            // HEADER
            Stack(
              clipBehavior: Clip.none,

              children: [

                Container(
                  height: 300,
                  width: double.infinity,

                  decoration: const BoxDecoration(

                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF2450C6),
                        Color(0xFF0C1E6F),
                      ],

                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),

                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),

                  child: Stack(
                    children: [

                      Positioned(
                        top: -80,
                        left: -40,

                        child: Container(
                          width: 420,
                          height: 220,

                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius:
                                BorderRadius.circular(300),
                          ),
                        ),
                      ),

                      SafeArea(

                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),

                          child: Row(
                            children: [

                              InkWell(

                                onTap: () {
                                  Navigator.pop(context);
                                },

                                child: const Row(
                                  children: [

                                    Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                      size: 18,
                                    ),

                                    SizedBox(width: 6),

                                    Text(
                                      "Kembali",

                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.center,

                        child: Container(
                          width: 230,
                          height: 230,

                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),

                          child: Center(

                            child: Container(
                              width: 170,
                              height: 170,

                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),

                              child: Center(

                                child: Image.asset(
                                  _getCategoryImage(
                                    widget.item.kategori,
                                  ),

                                  width: 110,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: -70,
                  left: 20,
                  right: 20,

                  child: Container(

                    padding: const EdgeInsets.all(22),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(22),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          widget.item.title,

                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                            color: Color(0xFF171725),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Row(
                          children: [

                            Icon(
                              Icons.calendar_today,
                              size: 15,
                              color: Colors.grey[600],
                            ),

                            const SizedBox(width: 7),

                            Text(
                              widget.item.tahun,

                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                              ),
                            ),

                            const Spacer(),

                            Icon(
                              Icons.grid_view_rounded,
                              size: 15,
                              color: Colors.grey[600],
                            ),

                            const SizedBox(width: 7),

                            Text(
                              widget.item.kategori,

                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        Row(
                          children: [

                            Icon(
                              Icons.access_time_filled,
                              size: 15,
                              color: Colors.grey[600],
                            ),

                            const SizedBox(width: 7),

                            Text(
                              widget.item.tanggal,

                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 13,
                              ),
                            ),

                            const Spacer(),

                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),

                            const SizedBox(width: 7),

                            Text(
                              widget.item.status,

                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100),

            // INSTANSI
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child: Container(

                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(18),

                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),

                child: Row(
                  children: [

                    Container(
                      width: 56,
                      height: 56,

                      padding: const EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(14),

                        border: Border.all(
                          color: Colors.grey.shade200,
                        ),
                      ),

                      child: Image.asset(
                        "assets/images/logo_jatim.png",
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Text(
                        widget.item.instansi,

                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                          color: Color(0xFF171725),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // SHARE
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child: Container(

                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(18),

                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                ),

                child: Row(
                  children: [

                    Text(
                      "Bagikan",

                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Icon(
                      Icons.link,
                      size: 20,
                      color: Colors.grey[600],
                    ),

                    const SizedBox(width: 10),

                    Icon(
                      Icons.facebook,
                      size: 20,
                      color: Colors.grey[600],
                    ),

                    const SizedBox(width: 10),

                    Icon(
                      Icons.flutter_dash,
                      size: 20,
                      color: Colors.grey[600],
                    ),

                    const SizedBox(width: 10),

                    Icon(
                      Icons.chat,
                      size: 20,
                      color: Colors.grey[600],
                    ),

                    const Spacer(),

                    Container(

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFF3366FF),

                        borderRadius:
                            BorderRadius.circular(10),
                      ),

                      child: const Text(
                        "Unduh",

                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // DATA
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Text(
                    "Data",

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF171725),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Container(

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(18),

                      border: Border.all(
                        color: Colors.grey.shade200,
                      ),
                    ),

                    child: Column(
                      children: [

                        _buildTableHeader(),

                        ...paginatedData.map(
                          (data) =>
                            _buildTableItem(
                            data.id,
                            data.periode,
                          )
                        ).toList(),

                        _buildPagination(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),

      child: Row(
      children: [

        const SizedBox(width: 40),

        _headerCell("No"),
        _headerCell("Periode\nUpdate"),
        _headerCell("Aksi"),
      ],
    ),
  );
}

  Widget _headerCell(String text) {

    return Expanded(

      child: Text(
        text,

        textAlign: TextAlign.center,

        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 13,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildTableItem(
    int number,
    String periode,
  ) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),

      child: Row(
        children: [

          SizedBox(
            width: 40,

            child: Align(
              alignment: Alignment.centerLeft,

              child: Container(
                width: 26,
                height: 26,

                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),

                  borderRadius:
                    BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          Expanded(
            child: Text(
              number.toString(),

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),

          Expanded(
            child: Text(
              periode.replaceAll(" ", "\n"),

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),

          Expanded(

            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                Container(

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F0FF),

                    borderRadius:
                        BorderRadius.circular(10),
                  ),

                  child: const Text(
                    "Detail",

                    style: TextStyle(
                      color: Color(0xFF3366FF),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Container(

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFF3366FF),

                    borderRadius:
                        BorderRadius.circular(10),
                  ),

                  child: const Text(
                    "Unduh",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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

  Widget _buildPagination() {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [

          InkWell(
            onTap: () {
              if (currentPage > 1) {

                setState(() {
                  currentPage--;
                });
              }
            },

            child: Container(
              width: 30,
              height: 30,

              decoration: BoxDecoration(
                color: Colors.grey.shade100,

                borderRadius:
                    BorderRadius.circular(8),
              ),

              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 14,
              ),
            ),
          ),

          Row(
            children: [

              ...List.generate(
                totalPage,
                (index) {

                  final page = index + 1;

                  return _pageItem(
                    page.toString(),
                    currentPage == page,
                  );
                },
              ),
            ],
          ),

          InkWell(
            onTap: () {
              if (currentPage < totalPage) {
                setState(() {
                  currentPage++;
                });
              }
            },

            child: Container(
              width: 30,
              height: 30,

              decoration: BoxDecoration(
                color: Colors.grey.shade100,

                borderRadius:
                    BorderRadius.circular(8),
              ),

              child: const Icon(
                Icons.arrow_forward_ios,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageItem(
  String text,
  bool active,
) {

  return InkWell(

    onTap: () {

      setState(() {
        currentPage = int.parse(text);
      });
    },

    child: Container(

      margin: const EdgeInsets.symmetric(
        horizontal: 4,
      ),

      width: 30,
      height: 30,

      decoration: BoxDecoration(

        color:
            active
                ? Colors.white
                : Colors.transparent,

        borderRadius:
            BorderRadius.circular(10),

        border:
            active
                ? Border.all(
                  color: Colors.grey.shade300,
                )
                : null,
      ),

      child: Center(

        child: Text(
          text,

          style: TextStyle(
            color:
                active
                    ? Colors.black
                    : Colors.grey[600],

            fontSize: 13,
          ),
        ),
      ),
    ),
  );
}

String _getCategoryImage(String kategori) {

  switch (kategori.toLowerCase()) {

    case "ekonomi":
      return "assets/images/openData/ekonomi.png";

    case "infrastruktur":
      return "assets/images/openData/infrastruktur.png";

    case "kemiskinan":
      return "assets/images/openData/kemiskinan.png";

    case "kependudukan":
      return "assets/images/openData/kependudukan.png";

    case "kesehatan":
      return "assets/images/openData/kesehatan.png";

    case "lingkungan hidup":
      return "assets/images/openData/lingkungan.png";

    case "pemerintah & desa":
      return "assets/images/openData/pemerintah.png";

    case "pendidikan":
      return "assets/images/openData/pendidikan.png";

    case "sosial":
      return "assets/images/openData/sosial.png";

    case "tata ruang":
      return "assets/images/openData/tataruang.png";

    default:
      return "assets/images/openData/ekonomi.png";
  }
}}
