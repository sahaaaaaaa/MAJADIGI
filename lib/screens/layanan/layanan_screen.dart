import 'dart:async';

import 'package:flutter/material.dart';
import 'package:majadigi/screens/beranda/home_service_item.dart';
import 'package:majadigi/screens/layanan/katalog_screen.dart';
import 'package:majadigi/screens/layanan/kategori_layanan_screen.dart';
import 'package:majadigi/screens/layanan/nawabhaktisatya_screen.dart';
import 'package:majadigi/services/layanan_service.dart';
import 'package:majadigi/widgets/asset_icon_image.dart';

import '../service_model.dart';

class LayananScreen extends StatefulWidget {
  const LayananScreen({super.key});

  @override
  State<LayananScreen> createState() => _LayananScreenState();
}

class _LayananScreenState extends State<LayananScreen> {
  final TextEditingController searchController = TextEditingController();
  final LayananService _layananService = LayananService();

  int selectedTab = 0;
  bool _isLoadingCategories = true;
  String? _categoryErrorMessage;
  List<LayananCategoryModel> _categories = [];

  final List<String> tabs = ["Layanan", "Nawa Bhakti Satya", "Katalog"];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    searchController.dispose();
    _layananService.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
      _categoryErrorMessage = null;
    });

    try {
      final categories = await _layananService.getPublicCategories();
      if (!mounted) {
        return;
      }

      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _categories = [];
        _isLoadingCategories = false;
        _categoryErrorMessage = 'Kategori layanan belum dapat dimuat.';
      });
    }
  }

  Future<void> showSearchDialog() async {
    var results = <LayananModel>[];
    var isLoading = false;
    var currentQuery = '';
    String? errorMessage;
    Timer? debounce;
    var isSheetOpen = true;

    Future<void> loadResults(StateSetter setModalState, String query) async {
      final keyword = query.trim();
      currentQuery = keyword;

      if (keyword.isEmpty) {
        setModalState(() {
          results = [];
          errorMessage = null;
          isLoading = false;
        });
        return;
      }

      setModalState(() {
        isLoading = true;
        errorMessage = null;
      });

      try {
        final services = await _layananService.getPublicLayanan(
          search: keyword,
        );
        if (!mounted || !isSheetOpen || currentQuery != keyword) {
          return;
        }

        setModalState(() {
          results = services;
          isLoading = false;
        });
      } catch (_) {
        if (!mounted || !isSheetOpen || currentQuery != keyword) {
          return;
        }

        setModalState(() {
          results = [];
          isLoading = false;
          errorMessage = 'Pencarian layanan belum dapat dimuat.';
        });
      }
    }

    void scheduleSearch(StateSetter setModalState, String query) {
      debounce?.cancel();
      debounce = Timer(
        const Duration(milliseconds: 350),
        () => loadResults(setModalState, query),
      );
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return FractionallySizedBox(
              heightFactor: 0.74,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onChanged: (value) =>
                          scheduleSearch(setModalState, value),
                      onSubmitted: (value) => loadResults(setModalState, value),
                      decoration: InputDecoration(
                        hintText: 'Cari layanan...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchController.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  searchController.clear();
                                  loadResults(setModalState, '');
                                },
                              ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Color(0xFFFF2E63)),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (isLoading) {
                            return const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          }

                          if (currentQuery.isEmpty) {
                            return const Center(
                              child: Text(
                                'Ketik nama layanan yang ingin dicari.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          if (results.isEmpty) {
                            return const Center(
                              child: Text(
                                'Layanan tidak ditemukan',
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }

                          return ListView.separated(
                            itemCount: results.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = results[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: const Color(0xffF5F7FF),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: AssetIconImage(
                                      asset: _serviceLogoPath(item),
                                    ),
                                  ),
                                ),
                                title: Text(layananDisplayTitle(item.name)),
                                subtitle: Text(
                                  item.categoryName.isEmpty
                                      ? 'Layanan'
                                      : item.categoryName,
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.pop(sheetContext);
                                  Future.microtask(
                                    () => _openServiceFromSearch(item),
                                  );
                                },
                              );
                            },
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
    ).whenComplete(() {
      isSheetOpen = false;
      debounce?.cancel();
      searchController.clear();
    });
  }

  void _openServiceFromSearch(LayananModel service) {
    final homeService = homeServiceFromLayanan(service);
    if (homeService != null) {
      Navigator.push(context, MaterialPageRoute(builder: homeService.builder));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Detail layanan belum tersedia.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _serviceLogoPath(LayananModel service) {
    final backendIcon = service.iconUrl.trim();
    if (backendIcon.startsWith('http') || backendIcon.startsWith('assets/')) {
      return backendIcon;
    }
    if (backendIcon.isNotEmpty) {
      return layananLogoAssetPath(backendIcon);
    }

    final homeService = homeServiceFromLayanan(service);
    return homeService?.image ??
        layananLogoAssetPath(layananLogoAssetName(service.name));
  }

  String _categoryImage(String title) {
    switch (title) {
      case 'Pariwisata & Kebudayaan':
        return 'assets/images/kategori/pariwisata_&_kebudayaan.svg';
      case 'Pendidikan':
        return 'assets/images/kategori/pendidikan.svg';
      case 'Ketenagakerjaan':
        return 'assets/images/kategori/ketenagakerjaan.svg';
      case 'Ekonomi & Bisnis':
        return 'assets/images/kategori/ekonomi_&_bisnis.svg';
      case 'Kesehatan':
        return 'assets/images/kategori/kesehatan.svg';
      case 'Kependudukan':
        return 'assets/images/kategori/kependudukan.svg';
      case 'Multisektor (Khusus)':
        return 'assets/images/kategori/multisektor_(khusus).svg';
      case 'Infrastruktur':
        return 'assets/images/kategori/infrastruktur.svg';
      case 'Sosial':
        return 'assets/images/kategori/sosial.svg';
      case 'Lingkungan Hidup':
        return 'assets/images/kategori/lingkungan_hidup.svg';
      case 'Kebencanaan':
        return 'assets/images/kategori/kebencanaan.svg';
      case 'Pemerintahan & Desa':
      case 'Pemerintah & Desa':
        return 'assets/images/kategori/pemerintah_&_Desa.svg';
      default:
        return 'assets/images/kategori/PPID.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: -430,
              child: Transform.rotate(
                angle: -60.94 * (3.14159 / 180),
                child: Container(
                  width: 950,
                  height: 850,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0047B3), Color(0xFF0065FF)],
                    ),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.elliptical(935, 791)),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 30, 24, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Semua Layanan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: showSearchDialog,
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: const Color(0xffE5E5E5)),
                          ),
                          child: Row(
                             children: [
                              _buildTab(
                                text: "Layanan",
                                width: width * 0.24,
                                index: 0,
                              ),

                              _buildTab(
                                text: "Nawa Bhakti Satya",
                                width: width * 0.42,
                                index: 1,
                              ),

                              _buildTab(
                                text: "Katalog",
                                width: width * 0.24,
                                index: 2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              if (selectedTab == 0) {
                                return _buildLayananGrid();
                              }

                              if (selectedTab == 1) {
                                return const NawaBhaktiScreen();
                              }

                              return const KatalogScreen();
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

  Widget _buildTab({
  required String text,
  required double width,
  required int index,
}) {
  final isActive = selectedTab == index;
  
  return GestureDetector(
    onTap: () {
      setState(() {
        selectedTab = index;
      });
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: width,
      padding: const EdgeInsets.symmetric(vertical: 12),

      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xffE9F0FF)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
      ),

      child: Center(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,

          style: TextStyle(
            fontSize: 13,
            fontWeight:
                isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive
                ? const Color(0xff2F61E8)
                : Colors.grey,
          ),
        ),
      ),
    ),
  );
}

  Widget _buildLayananGrid() {
    if (_isLoadingCategories) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    if (_categoryErrorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _categoryErrorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _loadCategories,
              child: const Text('Muat ulang'),
            ),
          ],
        ),
      );
    }

    if (_categories.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada kategori layanan tersedia.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCategories,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (context, index) {
          final item = _categories[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => KategoriLayananScreen(kategori: item.name),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xffEAEAEA)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xffF5F7FF),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      _categoryImage(item.name),
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.category_rounded,
                          color: Color(0xFF0E63FF),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: Text(
                      "Lihat daftar layanan dalam kategori ini.",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
