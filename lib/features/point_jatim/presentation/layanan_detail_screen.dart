import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:majadigi/features/point_jatim/data/point_jatim_service.dart';
import 'package:majadigi/features/point_jatim/presentation/point_jatim_dummy.dart';

class LayananDetailScreen extends StatelessWidget {
  final PointJatimProjectModel item;

  const LayananDetailScreen({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1E4FD8),

      body: Stack(
        children: [

          /// BACKGROUND HEADER
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

              /// APPBAR
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  55,
                  16,
                  0,
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
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18,
                          ),

                          SizedBox(width: 8),

                          Text(
                            'Kembali',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// BODY
              Expanded(
                child: Container(
                  width: double.infinity,

                  decoration: const BoxDecoration(
                    color: Color(0xffF6F6F6),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(34),
                      topRight: Radius.circular(34),
                    ),
                  ),

                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        /// IMAGE
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(24),

                          child: _buildPointJatimImage(
                            item.image,
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        /// FLOATING INFO CARD
                        Transform.translate(
                          offset: const Offset(0, -28),

                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            margin:
                                const EdgeInsets.symmetric(
                              horizontal: 12,
                            ),

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.08),
                                  blurRadius: 18,
                                  offset:
                                      const Offset(0, 8),
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.w700,
                                    height: 1.3,
                                    color:
                                        Color(0xff1C1C1C),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Row(
                                  children: [

                                    const Icon(
                                      Icons
                                          .account_balance_wallet_rounded,
                                      size: 16,
                                      color:
                                          Color(0xffFF8A00),
                                    ),

                                    const SizedBox(width: 4),

                                    Text(
                                      item.harga,
                                      style:
                                          const TextStyle(
                                        fontSize: 13,
                                        color: Color(
                                            0xff4B4B4B),
                                      ),
                                    ),

                                    const SizedBox(width: 14),

                                    const Icon(
                                      Icons
                                          .location_on_rounded,
                                      size: 16,
                                      color:
                                          Color(0xff1E4FD8),
                                    ),

                                    const SizedBox(width: 4),

                                    Expanded(
                                      child: Text(
                                        item.lokasi,
                                        overflow:
                                            TextOverflow
                                                .ellipsis,
                                        style:
                                            const TextStyle(
                                          fontSize: 13,
                                          color: Color(
                                              0xff4B4B4B),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 2),

                        /// INFOMEMO
                        const Text(
                          'Infomemo',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1B1B1B),
                          ),
                        ),

                        const SizedBox(height: 16),

                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(20),

                          child: SizedBox(
                            height: 220,

                            child: _infomemoImages.length == 1

                                /// SINGLE IMAGE
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(20),

                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,

                                          builder: (_) {

                                            return Dialog(
                                              backgroundColor: Colors.black,

                                              insetPadding:
                                                  const EdgeInsets.all(12),

                                              child: InteractiveViewer(
                                                child: _buildPointJatimImage(
                                                  _infomemoImages.first,
                                                  height: 500,
                                                  width: 500,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },

                                      child: _buildPointJatimImage(
                                        _infomemoImages.first,
                                        height: 220,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )

                                /// MULTIPLE IMAGE
                                : ListView.separated(
                                    scrollDirection: Axis.horizontal,

                                    itemCount:
                                        _infomemoImages.length,

                                    separatorBuilder:
                                        (_, __) =>
                                            const SizedBox(width: 14),

                                    itemBuilder: (context, index) {

                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20),

                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,

                                              builder: (_) {

                                                return Dialog(
                                                  backgroundColor: Colors.black,

                                                  insetPadding:
                                                      const EdgeInsets.all(12),

                                                  child: InteractiveViewer(
                                                    child: _buildPointJatimImage(
                                                      _infomemoImages[index],
                                                      height: 500,
                                                      width: 500,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },

                                          child: _buildPointJatimImage(
                                            _infomemoImages[index],
                                            height: 220,
                                            width: 320,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        /// DETAIL INFORMASI
                        const Text(
                          'Detail Informasi',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 18),

                        _buildDetailRow(
                          'Bidang Usaha',
                          item.category,
                        ),

                        _buildDetailRow(
                          'Tahun',
                          item.tahun,
                        ),

                        _buildDetailRow(
                          'Nilai Investasi',
                          item.harga,
                        ),

                        _buildDetailRow(
                          'Koordinat',
                          item.koordinat.isNotEmpty
                              ? item.koordinat
                              : '7.8496131, 112.4607358',
                        ),

                        _buildDetailRow(
                          'IRR',
                          item.irr.isNotEmpty ? item.irr : '19.82%',
                        ),

                        _buildDetailRow(
                          'NPV',
                          item.npv.isNotEmpty ? item.npv : 'Rp 7,85 Miliar',
                        ),

                        _buildDetailRow(
                          'Payback Period',
                          item.paybackPeriod.isNotEmpty
                              ? item.paybackPeriod
                              : '5.5 Tahun',
                          isLast: true,
                        ),

                        const SizedBox(height: 30),

                        /// DESKRIPSI
                        const Text(
                          'Deskripsi',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          item.deskripsi.isNotEmpty
                              ? item.deskripsi
                              : PointJatimDetailDummy.deskripsi,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                            height: 1.7,
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// LOKASI
                        const Text(
                          'Lokasi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff10162F),
                          ),
                        ),

                        const SizedBox(height: 16),

                        _buildMapPreview(),

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

  Widget _buildDetailRow(
    String title,
    String value, {
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),

      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(
                  color: Colors.grey.shade300,
                ),
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xff1D1D1D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> get _infomemoImages {
    final images = item.infomemoImages
        .map((image) => image.trim())
        .where((image) => image.isNotEmpty)
        .toList();
    if (images.isNotEmpty) {
      return images;
    }

    final image = item.image.trim();
    return [image.isNotEmpty ? image : PointJatimAssets.fallbackImage];
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
      return _buildImagePlaceholder(
        height: height,
        width: width,
      );
    }

    final isNetwork = resolvedImage.startsWith('http://') ||
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

          return _buildImagePlaceholder(
            height: height,
            width: width,
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder(
            height: height,
            width: width,
          );
        },
      );
    }

    return Image.asset(
      resolvedImage,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return _buildImagePlaceholder(
          height: height,
          width: width,
        );
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
        width: 64,
        height: 64,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildMapPreview() {
    if (item.lat == 0 && item.lon == 0) {
      return _buildMapPlaceholder('Koordinat tidak tersedia');
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: AspectRatio(
        aspectRatio: 0.96,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return _buildOpenStreetMapTiles(
              constraints.maxWidth,
              constraints.maxHeight,
            );
          },
        ),
      ),
    );
  }

  Widget _buildOpenStreetMapTiles(
    double width,
    double height,
  ) {
    const zoom = 15;
    const tileSize = 256.0;
    final tileCount = math.pow(2, zoom).toInt();
    final centerX = (item.lon + 180) / 360 * tileCount * tileSize;
    final latRad = item.lat * math.pi / 180;
    final centerY =
        (1 - math.log(math.tan(latRad) + 1 / math.cos(latRad)) / math.pi) /
            2 *
            tileCount *
            tileSize;
    final startTileX = ((centerX - width / 2) / tileSize).floor();
    final endTileX = ((centerX + width / 2) / tileSize).floor();
    final startTileY = ((centerY - height / 2) / tileSize).floor();
    final endTileY = ((centerY + height / 2) / tileSize).floor();
    final children = <Widget>[];

    for (var tileX = startTileX; tileX <= endTileX; tileX++) {
      for (var tileY = startTileY; tileY <= endTileY; tileY++) {
        if (tileY < 0 || tileY >= tileCount) {
          continue;
        }

        final wrappedTileX = ((tileX % tileCount) + tileCount) % tileCount;
        final left = tileX * tileSize - centerX + width / 2;
        final top = tileY * tileSize - centerY + height / 2;
        final url =
            'https://tile.openstreetmap.org/$zoom/$wrappedTileX/$tileY.png';

        children.add(
          Positioned(
            left: left,
            top: top,
            width: tileSize,
            height: tileSize,
            child: Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildTileFallback();
              },
            ),
          ),
        );
      }
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: const Color(0xffF1F2EF),
          ),
        ),
        ...children,
        Positioned.fill(
          child: Container(
            color: Colors.white.withOpacity(0.14),
          ),
        ),
      ],
    );
  }

  Widget _buildTileFallback() {
    return Container(
      color: const Color(0xffF1F2EF),
      child: CustomPaint(
        painter: _MapTileFallbackPainter(),
      ),
    );
  }

  Widget _buildMapPlaceholder(String text) {
    return Container(
      width: double.infinity,
      height: 370,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.location_on_rounded,
            size: 46,
            color: Color(0xff1E4FD8),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MapTileFallbackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    final waterPaint = Paint()
      ..color = const Color(0xffBCE9F5).withOpacity(0.75)
      ..strokeWidth = 26
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height * 0.82),
      Offset(size.width, size.height * 0.62),
      waterPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.32),
      Offset(size.width, size.height * 0.52),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.18, 0),
      Offset(size.width * 0.76, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
