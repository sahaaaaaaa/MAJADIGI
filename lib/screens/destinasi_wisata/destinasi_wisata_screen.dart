import 'package:flutter/material.dart';
import 'package:majadigi/services/destinasi_wisata_service.dart';
import 'detail_wisata_screen.dart';
import 'informasi_wisata.dart';

class DestinasiWisataScreen extends StatefulWidget {
  const DestinasiWisataScreen({super.key});

  @override
  State<DestinasiWisataScreen> createState() => _DestinasiWisataScreenState();
}

class _DestinasiWisataScreenState extends State<DestinasiWisataScreen> {
  static const Color _favoriteColor = Color(0xFFE53935);

  String lokasi = "Malang, Jawa Timur";
  late final DestinasiWisataService _wisataService;
  late final TextEditingController _searchController;
  bool _isLoading = true;
  String? _errorMessage;
  List<WisataDestination> _destinations = [];
  final Set<int> _favoriteRequestIds = <int>{};

  Map<String, bool> kategori = {
    "Dataran Tinggi/Gunung": true,
    "Pantai/Laut": false,
    "Air Terjun": false,
    "Wisata Buatan & Taman Hiburan": false,
    "Wisata Kota, Budaya, Edukasi": false,
  };

  @override
  void initState() {
    super.initState();
    _wisataService = DestinasiWisataService();
    _searchController = TextEditingController();
    _loadWisataData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _wisataService.dispose();
    super.dispose();
  }

  Future<void> _loadWisataData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        _wisataService.getDestinations(),
        _wisataService.getCategories(),
      ]);

      if (!mounted) {
        return;
      }

      final destinations = results[0] as List<WisataDestination>;
      final categories = results[1] as List<WisataCategory>;

      setState(() {
        _destinations = destinations;
        if (categories.isNotEmpty) {
          final selected = kategori.entries
              .where((entry) => entry.value)
              .map((entry) => entry.key)
              .toSet();
          kategori = {
            for (final item in categories)
              item.name: selected.isEmpty
                  ? false
                  : selected.contains(item.name),
          };
          if (!kategori.values.any((item) => item) && kategori.isNotEmpty) {
            kategori[kategori.keys.first] = true;
          }
        }
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = "Data destinasi wisata belum dapat dimuat.";
      });
    }
  }

  List<WisataDestination> get _filteredDestinations {
    final selectedCategories = kategori.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key.toLowerCase())
        .toSet();
    final query = _searchController.text.toLowerCase().trim();

    return _destinations.where((item) {
      final categoryMatch =
          selectedCategories.isEmpty ||
          _matchesSelectedCategory(
            item.category.toLowerCase(),
            selectedCategories,
          );
      final queryMatch =
          query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.city.toLowerCase().contains(query);

      return categoryMatch && queryMatch;
    }).toList();
  }

  bool _matchesSelectedCategory(
    String category,
    Set<String> selectedCategories,
  ) {
    return selectedCategories.any((selected) {
      return category == selected ||
          category.contains(selected) ||
          selected.contains(category);
    });
  }

  List<WisataDestination> get _popularDestinations {
    final data = [..._destinations]
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return data.take(5).toList();
  }

  Future<void> _openDetail(WisataDestination destination) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => DetailWisataScreen(
          destinationId: destination.id,
          initialDestination: destination,
        ),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    _setDestinationFavorite(destination.id, result);
  }

  void _setDestinationFavorite(int destinationId, bool isFavorite) {
    setState(() {
      _destinations = _destinations
          .map(
            (item) => item.id == destinationId
                ? item.copyWith(isFavorite: isFavorite)
                : item,
          )
          .toList();
    });
  }

  Future<void> _toggleFavorite(WisataDestination destination) async {
    if (_favoriteRequestIds.contains(destination.id)) {
      return;
    }

    final latestDestination = _destinations.firstWhere(
      (item) => item.id == destination.id,
      orElse: () => destination,
    );
    final wasFavorite = latestDestination.isFavorite;
    final nextValue = !wasFavorite;

    setState(() {
      _favoriteRequestIds.add(destination.id);
      _destinations = _destinations
          .map(
            (item) => item.id == destination.id
                ? item.copyWith(isFavorite: nextValue)
                : item,
          )
          .toList();
    });

    try {
      if (wasFavorite) {
        await _wisataService.removeFavorite(destination.id);
      } else {
        await _wisataService.addFavorite(destination.id);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _destinations = _destinations
            .map(
              (item) => item.id == destination.id
                  ? item.copyWith(isFavorite: wasFavorite)
                  : item,
            )
            .toList();
      });
    } finally {
      if (mounted) {
        setState(() {
          _favoriteRequestIds.remove(destination.id);
        });
      }
    }
  }

  void _showKategori() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Kategori",

                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  ...kategori.keys.map((key) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Expanded(child: Text(key)),

                            GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  kategori[key] = !(kategori[key] ?? false);
                                });
                              },

                              child: Container(
                                width: 24,
                                height: 24,

                                decoration: BoxDecoration(
                                  color: kategori[key]!
                                      ? const Color(0xFF0E63FF)
                                      : Colors.transparent,

                                  borderRadius: BorderRadius.circular(6),

                                  border: Border.all(
                                    color: kategori[key]!
                                        ? const Color(0xFF0E63FF)
                                        : Colors.grey,
                                  ),
                                ),

                                child: kategori[key]!
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
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
                            color: const Color(0xFFE9EEF6),

                            borderRadius: BorderRadius.circular(30),
                          ),

                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                kategori.updateAll((key, value) => false);
                              });
                              setModalState(() {
                                kategori.updateAll((key, value) => false);
                              });
                            },

                            child: const Text(
                              "Reset",

                              style: TextStyle(
                                color: Color(0xFF0E63FF),
                                fontWeight: FontWeight.w600,
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
                            color: const Color(0xFF0E63FF),

                            borderRadius: BorderRadius.circular(30),
                          ),

                          child: TextButton(
                            onPressed: () {
                              setState(() {});
                              Navigator.pop(context);
                            },

                            child: const Text(
                              "Terapkan",

                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
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
    final popularDestinations = _popularDestinations;
    final filteredDestinations = _filteredDestinations;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: CustomScrollView(
        slivers: [
          // ================= HEADER =================
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,

            backgroundColor: const Color(0xFF0B57D0),

            expandedHeight: 170,
            toolbarHeight: 70,
            elevation: 0,

            flexibleSpace: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/latar_belakang.png"),

                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),

            titleSpacing: 0,

            title: Padding(
              padding: const EdgeInsets.only(right: 16),

              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        "Destinasi Wisata",

                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const Icon(Icons.bookmark_border, color: Colors.white),

                  const SizedBox(width: 12),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) => const InformasiScreen(),
                        ),
                      );
                    },

                    child: const Icon(Icons.info_outline, color: Colors.white),
                  ),
                ],
              ),
            ),

            // ================= SEARCH =================
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(90),

              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),

                child: Container(
                  height: 58,

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(22),
                  ),

                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        lokasi = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Malang, Jawa Timur",

                      prefixIcon: const Icon(Icons.location_on_outlined),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(22),

                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ================= CONTENT =================
          SliverToBoxAdapter(
            // child: Transform.translate(
            //   offset: const Offset(0, -2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ================= KATEGORI =================
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/latar_belakang.png"),

                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),

                    child: GestureDetector(
                      onTap: _showKategori,

                      child: Container(
                        padding: const EdgeInsets.all(16),

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.circular(22),
                        ),

                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Row(
                              children: [
                                Icon(Icons.grid_view_outlined),

                                SizedBox(width: 10),

                                Text(
                                  "Kategori",

                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ================= CONTENT PUTIH =================
                Container(
                  color: const Color(0xFFF5F5F5),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        if (_errorMessage != null) _infoBox(_errorMessage!),

                        const Text(
                          "Wisata Populer di Malang",

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 14),

                        SizedBox(
                          height: 230,

                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: popularDestinations.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 16),
                                  itemBuilder: (context, index) {
                                    return _cardHorizontal(
                                      popularDestinations[index],
                                    );
                                  },
                                ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          "Semua Wisata",

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 16),

                        if (_isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (filteredDestinations.isEmpty)
                          _infoBox(
                            "Destinasi wisata belum tersedia untuk filter ini.",
                          )
                        else
                          ...filteredDestinations.map(_cardVertical),
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

  // ================= CARD HORIZONTAL =================
  Widget _cardHorizontal(WisataDestination destination) {
    return GestureDetector(
      onTap: () => _openDetail(destination),

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

              child: _wisataImage(
                destination.thumbnail,
                height: 110,
                width: double.infinity,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    destination.name,

                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    destination.shortDescription,

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

  // ================= CARD VERTICAL =================
  Widget _cardVertical(WisataDestination destination) {
    return GestureDetector(
      onTap: () => _openDetail(destination),

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

                  child: _wisataImage(
                    destination.thumbnail,
                    height: 180,
                    width: double.infinity,
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,

                  child: GestureDetector(
                    onTap: () => _toggleFavorite(destination),
                    child: Container(
                      padding: const EdgeInsets.all(6),

                      decoration: const BoxDecoration(
                        color: Colors.black26,
                        shape: BoxShape.circle,
                      ),

                      child: Icon(
                        destination.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: destination.isFavorite
                            ? _favoriteColor
                            : Colors.white,
                        size: 18,
                      ),
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
                    destination.name,

                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    destination.shortDescription,

                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,

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

                      Expanded(
                        child: Text(
                          destination.city,

                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(color: Color(0xFF0E63FF)),
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

  Widget _wisataImage(
    String image, {
    required double height,
    required double width,
  }) {
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return Image.network(
        image,
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/images/bromo.png",
            height: height,
            width: width,
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Image.asset(
      image.isEmpty ? "assets/images/bromo.png" : image,
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }

  Widget _infoBox(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        message,
        style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.4),
      ),
    );
  }
}
