import 'package:flutter/material.dart';
import '../../services/point_jatim_service.dart';
import '../../widgets/layanan_favorite_button.dart';
import 'point_jatim_dummy.dart';
import 'point_jatim_info_screen.dart';
import 'layanan_detail_screen.dart';

class PointJatimHomeScreen extends StatefulWidget {
  const PointJatimHomeScreen({super.key});

  @override
  State<PointJatimHomeScreen> createState() => _PointJatimHomeScreenState();
}

class _PointJatimHomeScreenState extends State<PointJatimHomeScreen> {
  final PointJatimService _pointJatimService = PointJatimService();
  final TextEditingController searchController = TextEditingController();

  String selectedKategori = 'Semua';
  String selectedWilayah = 'Semua';
  String selectedKomoditi = 'Semua';
  List<PointJatimProjectModel> _projects = PointJatimDummy.projects;
  List<PointJatimHighlightModel> _highlights = PointJatimDummy.highlights;
  List<String> _kategoriList = PointJatimDummy.kategoriList;
  List<String> _wilayahList = const ['Semua'];
  List<String> _komoditiList = const ['Semua'];

  @override
  void initState() {
    super.initState();
    _loadPointJatim();
  }

  @override
  void dispose() {
    searchController.dispose();
    _pointJatimService.dispose();
    super.dispose();
  }

  Future<void> _loadPointJatim() async {
    try {
      final results = await Future.wait<dynamic>([
        _pointJatimService.getSectors(),
        _pointJatimService.getKomoditi(),
        _pointJatimService.getRegions(),
        _pointJatimService.getPotensi(
          pageNo: 1,
          pageSize: 100,
          sortBy: 'id',
          order: 'DESC',
          jenis: 'IPRO',
        ),
      ]);

      final sectors = results[0] as List<PointJatimSector>;
      final komoditi = results[1] as List<PointJatimKomoditi>;
      final regions = results[2] as List<PointJatimRegion>;
      final potensi = results[3] as PointJatimPotensiResponse;
      final sectorNames = {
        for (final sector in sectors) sector.id: sector.description,
      };
      final komoditiNames = {
        for (final item in komoditi) item.id: item.description,
      };
      final projects = potensi.items
          .map((item) => _projectFromPotensi(item, sectorNames, komoditiNames))
          .toList();

      if (!mounted) {
        return;
      }

      final categories = <String>{
        'Semua',
        ...sectors
            .where((item) => item.statusActive)
            .map((item) => item.description)
            .where((category) => category.trim().isNotEmpty),
        ...projects
            .map((item) => item.category)
            .where((category) => category.trim().isNotEmpty),
      }.toList();
      final wilayah = <String>{
        'Semua',
        ...regions
            .where((item) => item.statusActive)
            .map((item) => item.description)
            .where((region) => region.trim().isNotEmpty),
        ...projects
            .map((item) => item.wilayah)
            .where((region) => region.trim().isNotEmpty),
      }.toList();
      final komoditiList = <String>{
        'Semua',
        ...komoditi
            .where((item) => item.statusActive)
            .map((item) => item.description)
            .where((name) => name.trim().isNotEmpty),
        ...projects
            .map((item) => item.komoditi)
            .where((name) => name.trim().isNotEmpty),
      }.toList();

      final highlightedProjects = projects
          .where((item) => item.image.trim().isNotEmpty)
          .take(3)
          .toList();
      final highlightSource = highlightedProjects.isNotEmpty
          ? highlightedProjects
          : projects.take(3).toList();

      setState(() {
        _projects = projects;
        _highlights = highlightSource
            .map(
              (item) => PointJatimHighlightModel(
                image: item.image,
                title: item.title,
                subtitle: item.lokasi,
              ),
            )
            .toList();
        _kategoriList = categories;
        _wilayahList = wilayah;
        _komoditiList = komoditiList;
        if (!_kategoriList.contains(selectedKategori)) {
          selectedKategori = 'Semua';
        }
        if (!_wilayahList.contains(selectedWilayah)) {
          selectedWilayah = 'Semua';
        }
        if (!_komoditiList.contains(selectedKomoditi)) {
          selectedKomoditi = 'Semua';
        }
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _projects = PointJatimDummy.projects;
        _highlights = PointJatimDummy.highlights;
        _kategoriList = PointJatimDummy.kategoriList;
        _wilayahList = const ['Semua'];
        _komoditiList = const ['Semua'];
      });
    }
  }

  PointJatimProjectModel _projectFromPotensi(
    PointJatimPotensiItem item,
    Map<int, String> sectorNames,
    Map<int, String> komoditiNames,
  ) {
    final sectorName = sectorNames[item.sectorTypeId]?.trim() ?? '';
    final komoditiName = komoditiNames[item.komoditiTypeId]?.trim() ?? '';
    final category = sectorName.isNotEmpty
        ? sectorName
        : item.businessField.isNotEmpty
        ? item.businessField
        : item.jenis.isNotEmpty
        ? item.jenis
        : 'Lainnya';
    final locationParts = <String>[
      if (item.district.isNotEmpty) item.district,
      if (item.city.isNotEmpty) item.city,
    ];
    final coordinate = item.lat != 0 || item.lon != 0
        ? '${_formatCoordinate(item.lat)}, ${_formatCoordinate(item.lon)}'
        : '-';

    return PointJatimProjectModel(
      image: item.imageUrl,
      category: category,
      title: item.title,
      lokasi: locationParts.isNotEmpty
          ? locationParts.join(', ')
          : item.address.isNotEmpty
          ? item.address
          : '-',
      harga: _formatMoneyCompact(item.investmentValue),
      tahun: item.year > 0 ? item.year.toString() : '-',
      infomemoImages: const [],
      deskripsi: item.description,
      koordinat: coordinate,
      irr: item.irr == 0 ? '0%' : '${_formatDecimal(item.irr)}%',
      npv: _formatMoneyCompact(item.npv),
      paybackPeriod: item.paybackPeriod == 0
          ? '-'
          : '${_formatDecimal(item.paybackPeriod)} Tahun',
      komoditi: komoditiName,
      wilayah: item.city,
      lat: item.lat,
      lon: item.lon,
    );
  }

  String _formatMoneyCompact(double value) {
    final sign = value < 0 ? '-' : '';
    final absolute = value.abs();

    if (absolute >= 1000000000000) {
      return '${sign}Rp ${_formatDecimal(absolute / 1000000000000)} Triliun';
    }
    if (absolute >= 1000000000) {
      return '${sign}Rp ${_formatDecimal(absolute / 1000000000)} Miliar';
    }
    if (absolute >= 1000000) {
      return '${sign}Rp ${_formatDecimal(absolute / 1000000)} Juta';
    }
    if (absolute > 0) {
      return '${sign}Rp ${_formatWholeNumber(absolute.round())}';
    }

    return 'Rp 0';
  }

  String _formatDecimal(double value) {
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  String _formatWholeNumber(int value) {
    final raw = value.toString();
    final buffer = StringBuffer();
    for (var index = 0; index < raw.length; index++) {
      final remaining = raw.length - index;
      buffer.write(raw[index]);
      if (remaining > 1 && remaining % 3 == 1) {
        buffer.write('.');
      }
    }
    return buffer.toString();
  }

  String _formatCoordinate(double value) {
    return value.toStringAsFixed(6);
  }

  void _openProjectDetail(PointJatimProjectModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LayananDetailScreen(item: item)),
    );
  }

  PointJatimProjectModel _projectFromHighlight(PointJatimHighlightModel item) {
    final title = item.title.trim().toLowerCase();
    final image = item.image.trim();

    for (final project in _projects) {
      if (project.title.trim().toLowerCase() == title) {
        return project;
      }
    }

    for (final project in _projects) {
      if (image.isNotEmpty && project.image.trim() == image) {
        return project;
      }
    }

    return PointJatimProjectModel(
      image: item.image,
      category: 'Point Jatim',
      title: item.title,
      lokasi: item.subtitle,
      harga: '-',
      tahun: '-',
      infomemoImages: const [],
      deskripsi: item.subtitle,
      wilayah: item.subtitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProjects = _projects.where((item) {
      final matchKategori = selectedKategori == 'Semua'
          ? true
          : item.category == selectedKategori;
      final matchWilayah = selectedWilayah == 'Semua'
          ? true
          : item.wilayah == selectedWilayah;
      final matchKomoditi = selectedKomoditi == 'Semua'
          ? true
          : item.komoditi == selectedKomoditi;

      final matchSearch = item.title.toLowerCase().contains(
        searchController.text.toLowerCase(),
      );

      return matchKategori && matchWilayah && matchKomoditi && matchSearch;
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
                image: AssetImage('assets/images/latar_belakang.png'),
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
                    padding: const EdgeInsets.only(top: 20, bottom: 30),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// SEARCH
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),

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
                                padding: EdgeInsets.only(left: 11, right: 1),

                                child: Icon(
                                  Icons.search,
                                  color: Color(0xFFA0A0A0),
                                  size: 30,
                                ),
                              ),

                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),

                                borderSide: const BorderSide(
                                  color: Color(0xFFE2E2E2),
                                  width: 1.2,
                                ),
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),

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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTap: () {
                              _showFilterSheet();
                            },
                            child: Container(
                              height: 55,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.grey.shade300),
                              ),

                              child: Row(
                                children: [
                                  Icon(
                                    Icons.grid_view_rounded,
                                    color: Colors.grey.shade400,
                                    size: 20,
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Text(
                                      'Filter',
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),

                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.grey.shade400,
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
                          padding: const EdgeInsets.symmetric(vertical: 20),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),

                                child: Text(
                                  'Project Terbaru',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              SizedBox(
                                height: 255,

                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,

                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),

                                  itemBuilder: (context, index) {
                                    final item = _highlights[index];

                                    return _buildHighlightCard(item);
                                  },

                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 14),

                                  itemCount: _highlights.length,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// TITLE
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),

                          child: Text(
                            'List Project Ready to Offer',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff1D1D1D),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        /// PROJECT LIST
                        if (filteredProjects.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            child: Text(
                              'Data tidak ditemukan',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),

                            itemCount: filteredProjects.length,

                            itemBuilder: (context, index) {
                              final item = filteredProjects[index];

                              return _buildProjectCard(context, item);
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
      padding: const EdgeInsets.fromLTRB(16, 55, 16, 0),

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
              const LayananFavoriteButton(
                serviceName: 'Point Jatim',
                lookupQuery: 'Point Jatim',
              ),

              const SizedBox(width: 2),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PointJatimInfoScreen(),
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

  Widget _buildPointJatimImage(
    String image, {
    required double height,
    required double width,
    required BoxFit fit,
  }) {
    final resolvedImage = image.trim();
    if (resolvedImage.isEmpty ||
        resolvedImage == PointJatimAssets.fallbackImage) {
      return _buildImagePlaceholder(height: height, width: width);
    }

    final isNetwork =
        resolvedImage.startsWith('http://') ||
        resolvedImage.startsWith('https://');

    if (isNetwork) {
      return Image.network(
        resolvedImage,
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return _buildImagePlaceholder(height: height, width: width);
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder(height: height, width: width);
        },
      );
    }

    return Image.asset(
      resolvedImage,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return _buildImagePlaceholder(height: height, width: width);
      },
    );
  }

  Widget _buildImagePlaceholder({
    required double height,
    required double width,
  }) {
    return Container(
      height: height,
      width: width,
      color: const Color(0xffEEF3FF),
      alignment: Alignment.center,
      child: Image.asset(
        PointJatimAssets.fallbackImage,
        width: 54,
        height: 54,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildHighlightCard(PointJatimHighlightModel item) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openProjectDetail(_projectFromHighlight(item)),
        child: SizedBox(
          width: 168,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: _buildPointJatimImage(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.subtitle,
                      maxLines: 1,
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
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, PointJatimProjectModel item) {
    return GestureDetector(
      onTap: () => _openProjectDetail(item),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              child: _buildPointJatimImage(
                item.image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xff2F61E8)),
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
                        style: TextStyle(color: Colors.grey.shade500),
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

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      dropdownColor: Colors.white,
      style: const TextStyle(color: Color(0xff1D1D1D), fontSize: 16),
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Color(0xff666666),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xff2F61E8)),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),

      builder: (context) {
        String tempKategori = selectedKategori;
        String tempWilayah = selectedWilayah;
        String tempKomoditi = selectedKomoditi;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Filter',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'Kategori',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 12),

                  _buildFilterDropdown(
                    value: tempKategori,
                    items: _kategoriList,
                    onChanged: (value) {
                      setModalState(() {
                        tempKategori = value ?? 'Semua';
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Wilayah',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 12),

                  _buildFilterDropdown(
                    value: tempWilayah,
                    items: _wilayahList,
                    onChanged: (value) {
                      setModalState(() {
                        tempWilayah = value ?? 'Semua';
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Komoditi',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 12),

                  _buildFilterDropdown(
                    value: tempKomoditi,
                    items: _komoditiList,
                    onChanged: (value) {
                      setModalState(() {
                        tempKomoditi = value ?? 'Semua';
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
                                selectedKategori = 'Semua';
                                selectedWilayah = 'Semua';
                                selectedKomoditi = 'Semua';
                              });

                              Navigator.pop(context);
                            },

                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xff2F61E8),

                              side: const BorderSide(color: Color(0xff2F61E8)),

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),

                            child: const Text('Reset'),
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
                                selectedKategori = tempKategori;
                                selectedWilayah = tempWilayah;
                                selectedKomoditi = tempKomoditi;
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

                            child: const Text('Terapkan'),
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
