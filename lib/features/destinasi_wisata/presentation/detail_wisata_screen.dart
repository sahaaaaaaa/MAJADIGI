import 'package:flutter/material.dart';
import 'package:majadigi/features/destinasi_wisata/data/destinasi_wisata_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailWisataScreen extends StatefulWidget {
  const DetailWisataScreen({
    super.key,
    this.destinationId,
    this.initialDestination,
    this.favorite,
  });

  final int? destinationId;
  final WisataDestination? initialDestination;
  final WisataFavorite? favorite;

  @override
  State<DetailWisataScreen> createState() => _DetailWisataScreenState();
}

class _DetailWisataScreenState extends State<DetailWisataScreen> {
  static const Color _favoriteColor = Color(0xFFE53935);
  static const String _fallbackMapsUrl =
      "https://maps.app.goo.gl/CNFKMwNEB9RgyXB89";

  late final DestinasiWisataService _wisataService;
  WisataDestinationDetail? _detail;
  bool _isFavorite = false;
  bool _isFavoriteBusy = false;
  bool _hasFavoriteInteraction = false;

  int? get _destinationId =>
      widget.destinationId ??
      widget.initialDestination?.id ??
      widget.favorite?.id;

  @override
  void initState() {
    super.initState();
    _wisataService = DestinasiWisataService();
    _isFavorite =
        widget.favorite != null ||
        (widget.initialDestination?.isFavorite ?? false);
    _loadDetail();
  }

  @override
  void dispose() {
    _wisataService.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    final id = _destinationId;
    if (id == null) {
      return;
    }

    try {
      final detail = await _wisataService.getDestinationDetail(id);
      if (!mounted) {
        return;
      }
      setState(() {
        _detail = detail;
        if (!_hasFavoriteInteraction) {
          _isFavorite =
              detail.isFavorite ||
              widget.favorite != null ||
              (widget.initialDestination?.isFavorite ?? false);
        }
      });
    } catch (_) {}
  }

  Future<void> _toggleFavorite() async {
    final id = _destinationId;
    if (id == null || _isFavoriteBusy) {
      return;
    }

    final wasFavorite = _isFavorite;
    final nextValue = !wasFavorite;
    setState(() {
      _hasFavoriteInteraction = true;
      _isFavoriteBusy = true;
      _isFavorite = nextValue;
    });

    try {
      if (wasFavorite) {
        await _wisataService.removeFavorite(id);
      } else {
        await _wisataService.addFavorite(id);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isFavorite = wasFavorite;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isFavoriteBusy = false;
        });
      }
    }
  }

  void _openMaps() async {
    final detail = _detail;
    final Uri url;

    if (detail != null && detail.hasCoordinate) {
      url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${detail.latitude},${detail.longitude}',
      );
    } else {
      url = Uri.parse(_fallbackMapsUrl);
    }

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  String get _name {
    return _detail?.name ??
        widget.initialDestination?.name ??
        widget.favorite?.name ??
        "Gunung Bromo";
  }

  String get _description {
    return _detail?.description ??
        widget.initialDestination?.shortDescription ??
        "Gunung berapi aktif di Jawa Timur";
  }

  String get _city {
    return _detail?.city ??
        widget.initialDestination?.city ??
        widget.favorite?.city ??
        "Kabupaten Probolinggo";
  }

  String get _address {
    return _detail?.address ??
        "Cemoro Lawang, Desa Ngadisari, Kec. Sukapura, Kabupaten Probolinggo";
  }

  String get _coordinate {
    final detail = _detail;
    if (detail != null && detail.hasCoordinate) {
      return "${detail.latitude.toStringAsFixed(6)}, "
          "${detail.longitude.toStringAsFixed(6)}";
    }
    return "-7.9324305, 112.9531326";
  }

  String get _status {
    final status = _detail?.status.toLowerCase() ?? '';
    if (status == 'active') {
      return 'Buka';
    }
    if (status.isNotEmpty) {
      return _detail!.status;
    }
    return 'Buka';
  }

  double get _rating {
    return _detail?.rating ?? widget.initialDestination?.rating ?? 4.8;
  }

  int get _totalReviews {
    return _detail?.totalReviews ??
        widget.initialDestination?.totalReviews ??
        0;
  }

  String get _primaryImage {
    final detailImage = _detail?.primaryImage ?? '';
    if (detailImage.isNotEmpty) {
      return detailImage;
    }
    return widget.initialDestination?.thumbnail ??
        widget.favorite?.thumbnail ??
        '';
  }

  List<String> get _photos {
    final images = _detail?.images ?? const [];
    if (images.isNotEmpty) {
      return images;
    }
    if (_primaryImage.isNotEmpty) {
      return [_primaryImage];
    }
    return const [
      "assets/images/bromo.png",
      "assets/images/bromo2.png",
      "assets/images/bromo3.png",
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          // 🔥 STICKY HEADER + IMAGE
          Stack(
            children: [
              // Latar Belakang Biru
              Container(
                width: double.infinity,
                height: 300,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/latar_belakang.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    // APPBAR
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () =>
                                Navigator.pop(context, _isFavorite),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                _name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: _toggleFavorite,
                            icon: Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _isFavorite
                                  ? _favoriteColor
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // IMAGE
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _wisataImage(
                          _primaryImage,
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // INFO CARD
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.orange,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${_rating.toStringAsFixed(1)} ($_totalReviews)",
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.location_on,
                                  color: Color(0xFF0E63FF),
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _city,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
              ),
            ],
          ),

          // 🔥 SCROLL AREA
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // FOTO
                const Text(
                  "Foto",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _photos.map(_fotoItem).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // LOKASI
                const Text(
                  "Lokasi",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: _openMaps,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/maps.png",
                          height: 240,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // DETAIL INFO
                const Text(
                  "Detail Informasi",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                _infoCard("Kabupaten/Kota", _city),
                _infoCard("Alamat", _address),
                _infoCard("Titik Koordinat", _coordinate),
                _infoCard("Deskripsi", _description),

                // STATUS
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Status",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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

  // FOTO ITEM
  Widget _fotoItem(String image) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _wisataImage(image, width: 220, height: 140),
      ),
    );
  }

  // 🔥 FIXED INFO CARD (SESUAI REQUEST)
  Widget _infoCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 JUDUL BOLD
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 4),

          // 🔥 ISI NORMAL
          Text(value, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }
}
