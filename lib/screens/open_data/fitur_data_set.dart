import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:majadigi/services/open_data_service.dart';
import 'fitur_detail_data_set.dart';
import 'package:majadigi/screens/open_data/open_data_dummy.dart';

class FiturDataSetScreen extends StatefulWidget {
  final String? selectedKategori;

  const FiturDataSetScreen({super.key, this.selectedKategori});

  @override
  State<FiturDataSetScreen> createState() => _FiturDataSetScreenState();
}

class _FiturDataSetScreenState extends State<FiturDataSetScreen> {
  List<String> selectedOrganisasi = [];
  List<String> selectedTopik = [];
  late final OpenDataService _openDataService;
  late final TextEditingController _searchController;
  Timer? _searchDebounce;
  bool _isLoading = true;
  String? _errorMessage;
  List<HighlightDataModel> _datasets = [];
  List<String> _organizationItems = [];
  List<String> _topicItems = [];
  int _totalDataset = 0;

  @override
  void initState() {
    super.initState();
    if (widget.selectedKategori != null) {
      selectedTopik = [widget.selectedKategori!];
    }
    _openDataService = OpenDataService();
    _searchController = TextEditingController();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _openDataService.dispose();
    super.dispose();
  }

  List<HighlightDataModel> get filteredDataset {
    return _datasets.where((item) {
      final matchTopik =
          selectedTopik.isEmpty ||
          selectedTopik.any(
            (e) => e.toLowerCase().trim() == item.kategori.toLowerCase().trim(),
          );

      final matchOrganisasi =
          selectedOrganisasi.isEmpty ||
          selectedOrganisasi.any(
            (e) => e.toLowerCase().trim() == item.instansi.toLowerCase().trim(),
          );

      return matchTopik && matchOrganisasi;
    }).toList();
  }

  Future<void> _loadInitialData() async {
    try {
      final results = await Future.wait([
        _openDataService.getOrganizations(),
        _openDataService.getTopics(),
      ]);

      if (!mounted) {
        return;
      }

      final organizations =
          (results[0] as OpenDataListResponse<OpenDataOrganization>).items;
      final topics = (results[1] as OpenDataListResponse<OpenDataTopic>).items;

      setState(() {
        _organizationItems = organizations.map((item) => item.name).toList();
        _topicItems = topics.map((item) => item.name).toList();
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _organizationItems = dummyOrganisasi;
        _topicItems = dummyTopik;
      });
    }

    await _loadDatasets();
  }

  Future<void> _loadDatasets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _openDataService.getDatasets(
        search: _searchController.text,
        perPage: 20,
        where: buildOpenDataWhere(
          topicName: selectedTopik.length == 1 ? selectedTopik.first : '',
          organizationName: selectedOrganisasi.length == 1
              ? selectedOrganisasi.first
              : '',
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _datasets = response.items.map(_datasetToHighlight).toList();
        _totalDataset = response.pagination.totalData;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _datasets = dummyHighlightData;
        _totalDataset = dummyHighlightData.length;
        _isLoading = false;
        _errorMessage = 'Dataset belum dapat dimuat dari server.';
      });
    }
  }

  void _onSearchChanged(String _) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 450), _loadDatasets);
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
                image: AssetImage('assets/images/latar_belakang.png'),
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
                            border: Border.all(color: Colors.grey.shade200),
                          ),

                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey[500]),

                              const SizedBox(width: 12),

                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: _onSearchChanged,
                                  onSubmitted: (_) => _loadDatasets(),
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
                                items: _organizationItems.isEmpty
                                    ? dummyOrganisasi
                                    : _organizationItems,
                                selectedItems: selectedOrganisasi,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: _buildDropdown(
                                title: "Pilih Topik",
                                items: _topicItems.isEmpty
                                    ? dummyTopik
                                    : _topicItems,
                                selectedItems: selectedTopik,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "${formatOpenDataNumber(_totalDataset)} Dataset ditemukan.",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 20),

                        if (_errorMessage != null) ...[
                          _buildInfoBox(_errorMessage!),
                          const SizedBox(height: 16),
                        ],

                        if (_isLoading)
                          _buildLoadingBox()
                        else if (filteredDataset.isEmpty)
                          _buildInfoBox("Dataset tidak ditemukan.")
                        else
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

                              final isSelected = selectedItems.contains(item);

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

                                    borderRadius: BorderRadius.circular(18),

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
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),

                                        width: 22,
                                        height: 22,

                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFF0D57E7)
                                              : Colors.white,

                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),

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
        ).then((_) => _loadDatasets());
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),

        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedItems.isEmpty
                    ? title
                    : "${selectedItems.length} dipilih",

                overflow: TextOverflow.ellipsis,

                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
            ),

            Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBox() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Color(0xFF0D57E7)),
      ),
    );
  }

  Widget _buildInfoBox(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.4),
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
            builder: (_) => FiturDetailDataSetScreen(item: item),
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
          border: Border.all(color: Colors.grey.shade200),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                CircleAvatar(
                  radius: 24,

                  backgroundColor: _getCategoryColor(
                    category,
                  ).withOpacity(0.12),

                  child: _getCategoryWidget(category),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    title,

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Icon(Icons.apartment, size: 14, color: Colors.grey[600]),

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
                Icon(Icons.calendar_today, size: 14),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    tahun,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Icon(
                  Icons.grid_view_rounded,
                  size: 14,
                  color: Colors.grey[600],
                ),

                const SizedBox(width: 6),

                Flexible(
                  child: Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
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

                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),

                const Spacer(),

                const Icon(Icons.check_circle, size: 14, color: Colors.green),

                const SizedBox(width: 6),

                Text(
                  status,

                  style: const TextStyle(color: Colors.green, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getCategoryWidget(String category) {
    switch (category) {
      case "Kesehatan":
        return SvgPicture.asset(
          'assets/images/openData/kesehatan.svg',
          width: 24,
          height: 24,
        );

      case "Kependudukan":
        return SvgPicture.asset(
          'assets/images/openData/kependudukan.svg',
          width: 24,
          height: 24,
        );

      case "Ekonomi":
        return SvgPicture.asset(
          'assets/images/openData/ekonomi.svg',
          width: 24,
          height: 24,
        );

      case "Lingkungan Hidup":
        return SvgPicture.asset(
          'assets/images/openData/lingkungan.svg',
          width: 24,
          height: 24,
        );

      case "Infrastruktur":
        return SvgPicture.asset(
          'assets/images/openData/infrastruktur.svg',
          width: 24,
          height: 24,
        );
      
      case "Kemiskinan":
        return SvgPicture.asset(
          'assets/images/openData/kemiskinan.svg',
          width: 24,
          height: 24,
        );
      
      case "Pemerintah & Desa":
        return SvgPicture.asset(
          'assets/images/openData/pemerintah.svg',
          width: 24,
          height: 24,
        );
      
      case "Pendidikan":
        return SvgPicture.asset(
          'assets/images/openData/pendidikan.svg',
          width: 24,
          height: 24,
        );
      
      case "Sosial":
        return SvgPicture.asset(
          'assets/images/openData/sosial.svg',
          width: 24,
          height: 24,
        );

      case "Tata Ruang":
        return SvgPicture.asset(
          'assets/images/openData/tataruang.svg',
          width: 24,
          height: 24,
        );

      default:
        return const Icon(Icons.dataset);
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

  HighlightDataModel _datasetToHighlight(OpenDataDataset dataset) {
    return HighlightDataModel(
      title: dataset.name,
      instansi: dataset.organizationName.isEmpty
          ? '-'
          : dataset.organizationName,
      tahun: dataset.dimension.isEmpty ? '-' : dataset.dimension,
      kategori: dataset.topicName.isEmpty ? 'Dataset' : dataset.topicName,
      tanggal: formatOpenDataDate(dataset.updatedAt),
      status: dataset.status.isEmpty ? '-' : dataset.status,
      slug: dataset.slug,
      schema: dataset.schema,
      table: dataset.table,
      organisasiImage: dataset.organizationImage,
      description: stripHtml(dataset.description),
      countView: dataset.viewCount,
      countDownload: dataset.downloadCount,
    );
  }
}
