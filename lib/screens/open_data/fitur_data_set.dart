import 'package:flutter/material.dart';
import 'fitur_detail_data_set.dart';
import 'package:majadigi/screens/open_data/open_data_dummy.dart';

class FiturDataSetScreen extends StatefulWidget  {
  
  final String? selectedKategori;

  const FiturDataSetScreen({
    super.key,
    this.selectedKategori,
  });

  @override
  State<FiturDataSetScreen> createState() => _FiturDataSetScreenState();
}

class _FiturDataSetScreenState extends State<FiturDataSetScreen> {
  List<String> selectedOrganisasi = [];
  List<String> selectedTopik = [];

  @override 
  void initState() { 
    super.initState(); 
    if (widget.selectedKategori != null) { 
      selectedTopik = [widget.selectedKategori!]; 
    } 
  }
  
  List<HighlightDataModel> get filteredDataset {

  return dummyHighlightData.where((item) {

    final matchTopik =
        selectedTopik.isEmpty ||

        selectedTopik.any(
          (e) =>
              e.toLowerCase().trim() ==
              item.kategori.toLowerCase().trim(),
        );

    final matchOrganisasi =
        selectedOrganisasi.isEmpty ||

        selectedOrganisasi.any(
          (e) =>
              e.toLowerCase().trim() ==
              item.instansi.toLowerCase().trim(),
        );

    return matchTopik && matchOrganisasi;

  }).toList();
  
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7),

      body: Stack(
        children: [

          // BACKGROUND
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

              // APPBAR
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 55, 18, 0),
                child: Row(
                  children: [

                    InkWell(
                      onTap: () => Navigator.pop(context),

                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),

                    const Expanded(
                      child: Center(
                        child: Text(
                          "Dataset",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // CONTENT
              Expanded(
                child: Container(
                  width: double.infinity,

                  decoration: const BoxDecoration(
                    color: Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(36),
                      topRight: Radius.circular(36),
                    ),
                  ),

                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // SEARCH
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                          ),

                          child: Row(
                            children: [

                              Icon(
                                Icons.search,
                                color: Colors.grey[500],
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Cari Dataset",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // FILTER
                        Row(
                          children: [

                            Expanded(
                              child: _buildDropdown(
                                title: "Pilih Organisasi",
                                items: dummyOrganisasi,
                                selectedItems: selectedOrganisasi,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: _buildDropdown(
                                title: "Pilih Topik",
                                items: dummyTopik,
                                selectedItems: selectedTopik,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "40.213 Dataset ditemukan.",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // LIST DATA
                        Column(
                          children: filteredDataset.map((item) {
                            return _buildDataCard(
                              item: item,
                              title: item.title,
                              category: item.kategori,
                              instansi: item.instansi,
                              tahun: item.tahun,
                              tanggal: item.tanggal,
                              status: item.status,
                            );
                          }).toList(),
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

  Widget _buildDropdown({
  required String title,
  required List<String> items,
  required List<String> selectedItems,
}) {
  return InkWell(
    onTap: () {
      showDialog(
        context: context,
        builder: (context) {

          return StatefulBuilder(
            builder: (context, setModalState) {

              return Dialog(
                backgroundColor: Colors.white,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),

                child: Container(
                  height: 520,
                  padding: const EdgeInsets.all(24),

                  child: Column(
                    children: [

                      // TITLE
                      Text(
                        title.replaceAll("Pilih ", ""),

                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D1B25),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // LIST
                      Expanded(
                        child: ListView.separated(

                          itemCount: items.length,

                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),

                          itemBuilder: (context, index) {

                            final item = items[index];

                            final isSelected =
                                selectedItems.contains(item);

                            return InkWell(

                              borderRadius: BorderRadius.circular(18),

                              onTap: () {

                                setState(() {

                                  if (isSelected) {
                                    selectedItems.remove(item);
                                  } else {
                                    selectedItems.add(item);
                                  }
                                });

                                setModalState(() {});
                              },

                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),

                                decoration: BoxDecoration(

                                  color: isSelected
                                      ? const Color(0xFFEAF2FF)
                                      : Colors.white,

                                  borderRadius:
                                      BorderRadius.circular(18),

                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF0D57E7)
                                        : Colors.grey.shade200,
                                  ),
                                ),

                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,

                                  children: [

                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),

                                      width: 22,
                                      height: 22,

                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF0D57E7)
                                            : Colors.white,

                                        borderRadius:
                                            BorderRadius.circular(6),

                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xFF0D57E7)
                                              : Colors.grey.shade400,
                                          width: 1.5,
                                        ),
                                      ),

                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),

                                    const SizedBox(width: 14),

                                    Expanded(
                                      child: Text(
                                        item,

                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.5,

                                          color: isSelected
                                              ? const Color(0xFF0D57E7)
                                              : const Color(0xFF2B2B2B),

                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                        ),
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
              );
            },
          );
        },
      );
    },

    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Row(
        children: [

          Expanded(
            child: Text(

              selectedItems.isEmpty
                  ? title
                  : "${selectedItems.length} dipilih",

              overflow: TextOverflow.ellipsis,

              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
              ),
            ),
          ),

          Icon(
            Icons.keyboard_arrow_down,
            color: Colors.grey[600],
          ),
        ],
      ),
    ),
  );
}

Widget _buildDataCard({

  required HighlightDataModel item,

  required String title,
  required String category,
  required String instansi,
  required String tahun,
  required String tanggal,
  required String status,
}) {

  return InkWell(

    borderRadius: BorderRadius.circular(20),

    onTap: () {

      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) =>
              FiturDetailDataSetScreen(
            item: item,
          ),
        ),
      );
    },

    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              CircleAvatar(
                radius: 24,

                backgroundColor:
                    _getCategoryColor(category)
                        .withOpacity(0.12),

                child: Icon(
                  _getCategoryIcon(category),
                  color:
                      _getCategoryColor(category),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  title,

                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Icon(
                Icons.apartment,
                size: 14,
                color: Colors.grey[600],
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  instansi,

                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [

              Icon(
                Icons.calendar_today,
                size: 14,
                color: Colors.grey[600],
              ),

              const SizedBox(width: 6),

              Text(
                tahun,

                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),

              const Spacer(),

              Icon(
                Icons.grid_view_rounded,
                size: 14,
                color: Colors.grey[600],
              ),

              const SizedBox(width: 6),

              Text(
                category,

                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              Icon(
                Icons.access_time_filled,
                size: 14,
                color: Colors.grey[600],
              ),

              const SizedBox(width: 6),

              Text(
                tanggal,

                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),

              const Spacer(),

              const Icon(
                Icons.check_circle,
                size: 14,
                color: Colors.green,
              ),

              const SizedBox(width: 6),

              Text(
                status,

                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
  

IconData _getCategoryIcon(String category) {

  switch (category) {

    case "Kesehatan":
      return Icons.local_hospital;

    case "Kependudukan":
      return Icons.badge;

    case "Lingkungan Hidup":
      return Icons.eco;

    case "Ekonomi":
      return Icons.payments;

    default:
      return Icons.dataset;
  }
}

Color _getCategoryColor(String category) {

  switch (category) {

    case "Kesehatan":
      return Colors.blue;

    case "Kependudukan":
      return Colors.indigo;

    case "Lingkungan Hidup":
      return Colors.green;

    case "Ekonomi":
      return Colors.orange;

    default:
      return Colors.grey;
  }
}
}