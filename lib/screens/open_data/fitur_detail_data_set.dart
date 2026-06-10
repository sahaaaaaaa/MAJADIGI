import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:majadigi/screens/open_data/fitur_detail_periode_screen.dart';
import 'package:majadigi/screens/open_data/open_data_dummy.dart';
import 'package:majadigi/services/open_data_service.dart';

class FiturDetailDataSetScreen extends StatefulWidget {
  final HighlightDataModel item;

  const FiturDetailDataSetScreen({super.key, required this.item});

  @override
  State<FiturDetailDataSetScreen> createState() =>
      _FiturDetailDataSetScreenState();
}

class _FiturDetailDataSetScreenState extends State<FiturDetailDataSetScreen> {
  static const double _selectColumnWidth = 56;
  static const double _noColumnWidth = 70;
  static const double _periodColumnWidth = 180;
  static const double _actionColumnWidth = 226;

  int currentPage = 1;
  bool isDetailMode = false;
  String selectedPeriode = "";
  String selectedPeriodeFilter = "";
  late final OpenDataService _openDataService;
  late HighlightDataModel _item;
  List<DataTableModel> _tableData = dummyTableData;
  List<DetailPeriodeModel> _detailRows = dummyDetailPeriode;
  List<String> _metadata = const [
    "id",
    "id_index",
    "kode_provinsi",
    "nama_provinsi",
    "kab_kota",
    "periode_update",
    "kategori",
    "jumlah",
    "satuan",
    "tahun",
  ];
  Map<String, List<String>> _metadataFilter = const {};
  bool _isLoadingDetail = false;
  String? _detailError;

  final int itemPerPage = 5;
  int get totalPage =>
      _tableData.isEmpty ? 1 : (_tableData.length / itemPerPage).ceil();

  List<DataTableModel> get paginatedData {
    final start = (currentPage - 1) * itemPerPage;
    final end = start + itemPerPage;
    if (start >= _tableData.length) {
      return [];
    }
    return _tableData.sublist(
      start,
      end > _tableData.length ? _tableData.length : end,
    );
  }

  @override
  void initState() {
    super.initState();
    _openDataService = OpenDataService();
    _item = widget.item;
    _loadDatasetDetail();
  }

  @override
  void dispose() {
    _openDataService.dispose();
    super.dispose();
  }

  Future<void> _loadDatasetDetail() async {
    if (_item.slug.isEmpty) {
      return;
    }

    setState(() {
      _isLoadingDetail = true;
      _detailError = null;
    });

    try {
      final detail = await _openDataService.getDatasetDetail(_item.slug);
      OpenDataCleanedBigData? cleaned;

      if (detail.schema.isNotEmpty && detail.table.isNotEmpty) {
        try {
          cleaned = await _openDataService.getCleanedBigDataAuto(
            schema: detail.schema,
            table: detail.table,
          );
        } catch (_) {}
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _item = _datasetToHighlight(detail);
        _tableData = cleaned == null
            ? _periodsFromDataset(detail)
            : _periodsFromCleanedData(cleaned, detail);
        if (cleaned != null && cleaned.rows.isNotEmpty) {
          _detailRows = _rowsFromCleanedData(cleaned);
          _metadata = cleaned.metadata.isEmpty ? _metadata : cleaned.metadata;
          _metadataFilter = cleaned.metadataFilter;
        }
        _isLoadingDetail = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _detailError = "Detail dataset belum dapat dimuat dari server.";
        _isLoadingDetail = false;
      });
    }
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
                      colors: [Color(0xFF2450C6), Color(0xFF0C1E6F)],

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
                            borderRadius: BorderRadius.circular(300),
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
                                  if (isDetailMode) {
                                    setState(() {
                                      isDetailMode = false;
                                    });
                                  } else {
                                    Navigator.pop(context);
                                  }
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
                                        fontWeight: FontWeight.w500,
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
                                child: SvgPicture.asset(
                                  _getCategoryImage(_item.kategori),

                                  width: 110,
                                  height: 110,
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

                      borderRadius: BorderRadius.circular(22),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          _item.title,

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
                              _item.tahun,

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
                              _item.kategori,

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
                              _item.tanggal,

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
                              _item.status,

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
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Container(
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(18),

                  border: Border.all(color: Colors.grey.shade200),
                ),

                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,

                      padding: const EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),

                        border: Border.all(color: Colors.grey.shade200),
                      ),

                      child: _buildOrganizationImage(),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Text(
                        _item.instansi,

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
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(18),

                  border: Border.all(color: Colors.grey.shade200),
                ),

                child: Row(
                  children: [
                    Text(
                      "Bagikan",

                      style: TextStyle(color: Colors.grey[600], fontSize: 15),
                    ),

                    const SizedBox(width: 10),

                    Icon(Icons.link, size: 20, color: Colors.grey[600]),

                    const SizedBox(width: 10),

                    Icon(Icons.facebook, size: 20, color: Colors.grey[600]),

                    const SizedBox(width: 10),

                    Icon(Icons.flutter_dash, size: 20, color: Colors.grey[600]),

                    const SizedBox(width: 10),

                    Icon(Icons.chat, size: 20, color: Colors.grey[600]),

                    const Spacer(),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFF3366FF),

                        borderRadius: BorderRadius.circular(10),
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
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // DATA
                  if (!isDetailMode)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

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

                        if (_isLoadingDetail)
                          _buildDetailStatus(
                            "Memuat detail dataset dari Open Data...",
                          ),

                        if (_detailError != null)
                          _buildDetailStatus(_detailError!, isError: true),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,

                            borderRadius: BorderRadius.circular(18),

                            border: Border.all(color: Colors.grey.shade200),
                          ),

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              child: SizedBox(
                                width: _periodTableWidth(context),
                                child: Column(
                                  children: [
                                    _buildTableHeader(),

                                    ...paginatedData.map(_buildTableItem),

                                    _buildPagination(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  if (isDetailMode)
                    FiturDetailPeriodeScreen(
                      periode: selectedPeriode,
                      periodeFilter: selectedPeriodeFilter,
                      rows: _detailRows,
                      metadata: _metadata,
                      metadataFilter: _metadataFilter,

                      onBack: () {
                        setState(() {
                          isDetailMode = false;
                        });
                      },
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),

      child: Row(
        children: [
          const SizedBox(width: _selectColumnWidth),

          _headerCell("No", _noColumnWidth),
          _headerCell("Periode\nUpdate", _periodColumnWidth),
          _headerCell("Aksi", _actionColumnWidth),
        ],
      ),
    );
  }

  Widget _buildDetailStatus(String message, {bool isError = false}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isError ? const Color(0xFFFFF2F2) : const Color(0xFFEAF3FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError ? const Color(0xFFFFD0D0) : const Color(0xFFD5E5FF),
        ),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: isError ? const Color(0xFFB42318) : const Color(0xFF183B73),
          fontSize: 13,
          height: 1.4,
        ),
      ),
    );
  }

  double _periodTableWidth(BuildContext context) {
    final contentWidth =
        _selectColumnWidth +
        _noColumnWidth +
        _periodColumnWidth +
        _actionColumnWidth +
        32;
    final viewportWidth = MediaQuery.sizeOf(context).width - 40;

    return contentWidth > viewportWidth ? contentWidth : viewportWidth;
  }

  Widget _headerCell(String text, double width) {
    return SizedBox(
      width: width,
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

  Widget _buildTableItem(DataTableModel data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),

      child: Row(
        children: [
          SizedBox(
            width: _selectColumnWidth,

            child: Align(
              alignment: Alignment.centerLeft,

              child: Container(
                width: 26,
                height: 26,

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),

                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          SizedBox(
            width: _noColumnWidth,
            child: Text(
              data.id.toString(),

              textAlign: TextAlign.center,

              style: const TextStyle(fontSize: 14),
            ),
          ),

          SizedBox(
            width: _periodColumnWidth,
            child: Text(
              data.periode,

              textAlign: TextAlign.center,

              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),

          SizedBox(
            width: _actionColumnWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDetailMode = true;

                      selectedPeriode = data.periode;
                      selectedPeriodeFilter = data.periodeFilter;
                    });
                  },

                  child: _actionButton(
                    label: "Detail",
                    foreground: const Color(0xFF3366FF),
                    background: const Color(0xFFE9F0FF),
                  ),
                ),

                const SizedBox(width: 8),

                _actionButton(
                  label: "Unduh",
                  foreground: Colors.white,
                  background: const Color(0xFF3366FF),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color foreground,
    required Color background,
  }) {
    return Container(
      width: 94,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: foreground,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

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

                borderRadius: BorderRadius.circular(8),
              ),

              child: const Icon(Icons.arrow_back_ios_new, size: 14),
            ),
          ),

          Expanded(
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(totalPage, (index) {
                      final page = index + 1;

                      return _pageItem(page.toString(), currentPage == page);
                    }),
                  ],
                ),
              ),
            ),
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

                borderRadius: BorderRadius.circular(8),
              ),

              child: const Icon(Icons.arrow_forward_ios, size: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageItem(String text, bool active) {
    return InkWell(
      onTap: () {
        setState(() {
          currentPage = int.parse(text);
        });
      },

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),

        width: 30,
        height: 30,

        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,

          borderRadius: BorderRadius.circular(10),

          border: active ? Border.all(color: Colors.grey.shade300) : null,
        ),

        child: Center(
          child: Text(
            text,

            style: TextStyle(
              color: active ? Colors.black : Colors.grey[600],

              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrganizationImage() {
    final url = resolveOpenDataAssetUrl(_item.organisasiImage);

    if (url.isEmpty) {
      return Image.asset(
        "assets/images/logo_majadigi.svg",
        fit: BoxFit.contain,
      );
    }

    return Image.network(
      url,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          "assets/images/logo_majadigi.svg",
          fit: BoxFit.contain,
        );
      },
    );
  }

  HighlightDataModel _datasetToHighlight(OpenDataDataset dataset) {
    return HighlightDataModel(
      title: dataset.name,
      instansi: dataset.organizationName,
      tahun: dataset.dimension.isEmpty ? dataset.period : dataset.dimension,
      kategori: dataset.topicName,
      tanggal: formatOpenDataDate(dataset.updatedAt),
      status: dataset.status.isEmpty ? "Tetap" : dataset.status,
      slug: dataset.slug,
      schema: dataset.schema,
      table: dataset.table,
      organisasiImage: dataset.organizationImage,
      description: stripHtml(dataset.description),
      countView: dataset.viewCount,
      countDownload: dataset.downloadCount,
    );
  }

  List<DataTableModel> _periodsFromDataset(OpenDataDataset dataset) {
    if (dataset.periodUpdates.isEmpty) {
      if (dataset.period.isEmpty) {
        return _tableData;
      }

      return [
        DataTableModel(
          id: 1,
          periode: dataset.period,
          periodeFilter: dataset.period,
        ),
      ];
    }

    return dataset.periodUpdates.asMap().entries.map((entry) {
      final item = entry.value;
      final filter = item.labelFormat.isNotEmpty
          ? item.labelFormat
          : item.label;

      return DataTableModel(
        id: entry.key + 1,
        periode: _periodLabel(filter),
        periodeFilter: filter,
      );
    }).toList();
  }

  List<DataTableModel> _periodsFromCleanedData(
    OpenDataCleanedBigData cleaned,
    OpenDataDataset dataset,
  ) {
    final filterPeriods = cleaned.metadataFilter["periode_update"];
    final rawPeriods = filterPeriods == null || filterPeriods.isEmpty
        ? cleaned.rows
              .map((row) => _rowText(row, "periode_update"))
              .where((item) => item.isNotEmpty)
              .toSet()
              .toList()
        : filterPeriods;

    if (rawPeriods.isEmpty) {
      return _periodsFromDataset(dataset);
    }

    final sortedPeriods = [...rawPeriods]..sort((a, b) => b.compareTo(a));

    return sortedPeriods.asMap().entries.map((entry) {
      final raw = entry.value;

      return DataTableModel(
        id: entry.key + 1,
        periode: _periodLabel(raw),
        periodeFilter: raw,
      );
    }).toList();
  }

  List<DetailPeriodeModel> _rowsFromCleanedData(
    OpenDataCleanedBigData cleaned,
  ) {
    return cleaned.rows.asMap().entries.map((entry) {
      final row = entry.value;
      final values = <String, String>{};

      for (final key in cleaned.metadata) {
        values[key] = _rowText(row, key);
      }

      for (final item in row.entries) {
        values.putIfAbsent(item.key, () => item.value?.toString() ?? "");
      }

      return DetailPeriodeModel(
        id: _rowInt(row, "id", fallback: entry.key + 1),
        idIndex: _rowInt(row, "id_index", fallback: entry.key + 1),
        kodeProvinsi: _rowText(row, "kode_provinsi"),
        namaProvinsi: _rowText(row, "nama_provinsi"),
        kabKota: _rowText(row, "kab_kota"),
        jumlahPosko: _rowInt(row, "jumlah"),
        periodeUpdate: _rowText(row, "periode_update"),
        satuan: _rowText(row, "satuan"),
        tahun: _rowText(row, "tahun"),
        kategori: _rowText(row, "kategori"),
        values: values,
      );
    }).toList();
  }

  String _rowText(Map<String, dynamic> row, String key) {
    return row[key]?.toString() ?? "";
  }

  int _rowInt(Map<String, dynamic> row, String key, {int fallback = 0}) {
    final value = row[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? "") ?? fallback;
  }

  String _periodLabel(String value) {
    final parts = value.split("-");

    if (parts.length == 2) {
      final year = parts.first;
      final month = int.tryParse(parts.last);
      const months = [
        "Januari",
        "Februari",
        "Maret",
        "April",
        "Mei",
        "Juni",
        "Juli",
        "Agustus",
        "September",
        "Oktober",
        "November",
        "Desember",
      ];

      if (month != null && month >= 1 && month <= 12) {
        return "${months[month - 1]} $year";
      }
    }

    return value;
  }

  String _getCategoryImage(String kategori) {
    switch (kategori.toLowerCase()) {
      case "ekonomi":
        return "assets/images/openData/ekonomi.svg";

      case "infrastruktur":
        return "assets/images/openData/infrastruktur.svg";

      case "kemiskinan":
        return "assets/images/openData/kemiskinan.svg";

      case "kependudukan":
        return "assets/images/openData/kependudukan.svg";

      case "kesehatan":
        return "assets/images/openData/kesehatan.svg";

      case "lingkungan hidup":
        return "assets/images/openData/lingkungan.svg";

      case "pemerintah & desa":
        return "assets/images/openData/pemerintah.svg";

      case "pendidikan":
        return "assets/images/openData/pendidikan.svg";

      case "sosial":
        return "assets/images/openData/sosial.svg";

      case "tata ruang":
        return "assets/images/openData/tataruang.svg";

      default:
        return "assets/images/openData/ekonomi.svg";
    }
  }
}
