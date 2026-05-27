import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../services/transjatim_service.dart';

class DetailRuteScreen extends StatefulWidget {
  final String code;
  final String from;
  final String to;
  final String time;

  const DetailRuteScreen({
    super.key,
    required this.code,
    required this.from,
    required this.to,
    required this.time,
  });

  @override
  State<DetailRuteScreen> createState() => _DetailRuteScreenState();
}

class _DetailRuteScreenState extends State<DetailRuteScreen> {
  final TransjatimService _transjatimService = TransjatimService();

  int selectedHalte = 0;
  bool _isReversed = false;
  TransjatimBusStopResponse? _busStopResponse;

  static const List<String> _fallbackHaltes = [
    "Halte Terminal Porong",
    "Halte Gedang",
    "Halte Tanggulangin",
    "Halte Keramean",
    "Halte Terminal Larangan",
  ];

  List<String> get haltes {
    final stops = _orderedStops;
    if (stops.isEmpty) {
      return _isReversed ? _fallbackHaltes.reversed.toList() : _fallbackHaltes;
    }
    return stops.map((item) => item.name).toList();
  }

  String get _origin {
    final routes = _busStopResponse?.routes ?? const [];
    if (routes.length > 1) {
      return _isReversed ? routes[1] : routes[0];
    }
    return _isReversed ? widget.to : widget.from;
  }

  String get _destination {
    final routes = _busStopResponse?.routes ?? const [];
    if (routes.length > 1) {
      return _isReversed ? routes[0] : routes[1];
    }
    return _isReversed ? widget.from : widget.to;
  }

  List<TransjatimBusStop> get _orderedStops {
    final stops = _busStopResponse?.stops ?? const [];
    if (!_isReversed) {
      return stops;
    }
    return stops.reversed.toList();
  }

  List<_GeoPoint> get _stopPoints {
    return _orderedStops
        .map((stop) {
          final lat = _parseCoordinate(stop.latitude);
          final lon = _parseCoordinate(stop.longitude);
          if (lat == null || lon == null) {
            return null;
          }
          return _GeoPoint(lat, lon, stop.name);
        })
        .whereType<_GeoPoint>()
        .toList();
  }

  List<_GeoPoint> get _routePoints {
    final decoded = _decodePolyline(_busStopResponse?.polyline ?? '');
    if (decoded.isNotEmpty) {
      return _isReversed ? decoded.reversed.toList() : decoded;
    }
    return _stopPoints;
  }

  int get _safeSelectedHalte {
    final items = haltes;
    if (items.isEmpty) {
      return 0;
    }
    return selectedHalte.clamp(0, items.length - 1).toInt();
  }

  Color get _routeColor {
    final colorHex = _orderedStops.isNotEmpty
        ? _orderedStops.first.colorHex
        : '';
    return _colorFromHex(colorHex, fallback: const Color(0xFF27AE60));
  }

  @override
  void initState() {
    super.initState();
    _loadBusStops();
  }

  @override
  void dispose() {
    _transjatimService.dispose();
    super.dispose();
  }

  Future<void> _loadBusStops() async {
    try {
      final busStops = await _transjatimService.getBusStops(widget.code);
      if (!mounted) {
        return;
      }
      setState(() {
        _busStopResponse = busStops;
        selectedHalte = 0;
      });
    } catch (_) {}
  }

  void _toggleDirection() {
    setState(() {
      _isReversed = !_isReversed;
      selectedHalte = 0;
    });
  }

  double? _parseCoordinate(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    if (normalized.isEmpty) {
      return null;
    }
    return double.tryParse(normalized);
  }

  Color _colorFromHex(String value, {required Color fallback}) {
    final hex = value.replaceAll('#', '').trim();
    if (hex.isEmpty) {
      return fallback;
    }
    final normalized = hex.length == 6 ? 'FF$hex' : hex;
    return Color(int.tryParse(normalized, radix: 16) ?? fallback.toARGB32());
  }

  List<_GeoPoint> _decodePolyline(String encoded) {
    if (encoded.trim().isEmpty) {
      return const [];
    }

    final points = <_GeoPoint>[];
    var index = 0;
    var lat = 0;
    var lon = 0;

    try {
      while (index < encoded.length) {
        var result = 0;
        var shift = 0;
        int byte;

        do {
          byte = encoded.codeUnitAt(index++) - 63;
          result |= (byte & 0x1f) << shift;
          shift += 5;
        } while (byte >= 0x20 && index < encoded.length);

        final deltaLat = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
        lat += deltaLat;

        result = 0;
        shift = 0;

        do {
          byte = encoded.codeUnitAt(index++) - 63;
          result |= (byte & 0x1f) << shift;
          shift += 5;
        } while (byte >= 0x20 && index < encoded.length);

        final deltaLon = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
        lon += deltaLon;

        points.add(_GeoPoint(lat / 1e5, lon / 1e5, ''));
      }
    } catch (_) {
      return const [];
    }

    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Stack(
        children: [
          // HEADER BG
          Container(
            width: double.infinity,
            height: 230,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/latar_belakang.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),

                      Expanded(
                        child: Text(
                          widget.code,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: double.infinity,

                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),

                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(34),
                        ),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(16),

                        child: Column(
                          children: [
                            // MAPS
                            _buildRouteMap(),

                            // JAM
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),

                              decoration: const BoxDecoration(
                                color: Color(0xFF27AE60),

                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20),
                                ),
                              ),

                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/images/icons/clock_white.svg',
                                    width: 18,
                                  ),

                                  const SizedBox(width: 10),

                                  Text(
                                    "Jam Operasional ${widget.time}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            // DARI KE
                            Container(
                              padding: const EdgeInsets.all(16),

                              decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(20),

                                border: Border.all(color: Colors.grey.shade300),
                              ),

                              child: Column(
                                children: [
                                  _routeField(
                                    label: "Dari",
                                    value: _origin,
                                    icon:
                                        'assets/images/icons/marker-pin-02.svg',
                                  ),

                                  const SizedBox(height: 14),

                                  Stack(
                                    clipBehavior: Clip.none,

                                    children: [
                                      _routeField(
                                        label: "Ke",
                                        value: _destination,
                                        icon:
                                            'assets/images/icons/marker-pin-02.svg',
                                      ),

                                      Positioned(
                                        right: -5,
                                        top: -15,

                                        child: Material(
                                          color: Colors.white,
                                          shape: CircleBorder(
                                            side: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          child: InkWell(
                                            customBorder: const CircleBorder(),
                                            onTap: _toggleDirection,
                                            child: SizedBox(
                                              width: 48,
                                              height: 48,
                                              child: Center(
                                                child: SvgPicture.asset(
                                                  'assets/images/icons/switch-vertical-01.svg',
                                                  width: 22,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            // HALTE LIST
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),

                              decoration: BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.circular(20),

                                border: Border.all(color: Colors.grey.shade300),
                              ),

                              child: Column(
                                children: List.generate(haltes.length, (index) {
                                  final isActive = selectedHalte == index;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedHalte = index;
                                      });
                                    },

                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,

                                      children: [
                                        Column(
                                          children: [
                                            SvgPicture.asset(
                                              isActive
                                                  ? 'assets/images/icons/marker-pin-green.svg'
                                                  : 'assets/images/icons/ellipse2.svg',

                                              width: 14,
                                            ),

                                            if (index != haltes.length - 1)
                                              Container(
                                                width: 2,
                                                height: 38,
                                                color: const Color(0xFFD9D9D9),
                                              ),
                                          ],
                                        ),

                                        const SizedBox(width: 14),

                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 0,
                                            ),

                                            child: Text(
                                              haltes[index],

                                              style: TextStyle(
                                                fontSize: 16,

                                                fontWeight: isActive
                                                    ? FontWeight.w600
                                                    : FontWeight.normal,

                                                color: isActive
                                                    ? const Color(0xFF27AE60)
                                                    : Colors.grey.shade700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
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

  Widget _routeField({
    required String label,
    required String value,
    required String icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Row(
        children: [
          SvgPicture.asset(icon, width: 22),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF121938),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteMap() {
    final stopPoints = _stopPoints;
    if (stopPoints.isEmpty) {
      return _buildStaticRouteMap();
    }

    const mapHeight = 380.0;
    final routePoints = _routePoints.isNotEmpty ? _routePoints : stopPoints;
    final activeIndex = _safeSelectedHalte.clamp(0, stopPoints.length - 1);
    final activePoint = stopPoints[activeIndex];

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: mapHeight,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final viewport = _RouteMapViewport.fit(
              points: [...routePoints, ...stopPoints],
              width: width,
              height: mapHeight,
            );

            return Stack(
              children: [
                Positioned.fill(
                  child: _buildOpenStreetMapTiles(
                    viewport: viewport,
                    width: width,
                    height: mapHeight,
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: _TransjatimRoutePainter(
                      routePoints: routePoints,
                      stopPoints: stopPoints,
                      activeIndex: activeIndex,
                      routeColor: _routeColor,
                      viewport: viewport,
                    ),
                  ),
                ),
                _buildHalteMapLabel(
                  point: activePoint,
                  viewport: viewport,
                  width: width,
                  height: mapHeight,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildOpenStreetMapTiles({
    required _RouteMapViewport viewport,
    required double width,
    required double height,
  }) {
    const tileSize = 256.0;
    final tileCount = math.pow(2, viewport.zoom).toInt();
    final startTileX = ((viewport.centerX - width / 2) / tileSize).floor();
    final endTileX = ((viewport.centerX + width / 2) / tileSize).floor();
    final startTileY = ((viewport.centerY - height / 2) / tileSize).floor();
    final endTileY = ((viewport.centerY + height / 2) / tileSize).floor();
    final children = <Widget>[
      Positioned.fill(child: Container(color: const Color(0xffEDF3EE))),
    ];

    for (var tileX = startTileX; tileX <= endTileX; tileX++) {
      for (var tileY = startTileY; tileY <= endTileY; tileY++) {
        if (tileY < 0 || tileY >= tileCount) {
          continue;
        }

        final wrappedTileX = ((tileX % tileCount) + tileCount) % tileCount;
        final left = tileX * tileSize - viewport.centerX + width / 2;
        final top = tileY * tileSize - viewport.centerY + height / 2;
        final url =
            'https://tile.openstreetmap.org/${viewport.zoom}/$wrappedTileX/$tileY.png';

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

    children.add(
      Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
      ),
    );

    return Stack(children: children);
  }

  Widget _buildHalteMapLabel({
    required _GeoPoint point,
    required _RouteMapViewport viewport,
    required double width,
    required double height,
  }) {
    final offset = viewport.project(point);
    final labelWidth = math.min(320.0, math.max(180.0, width - 32));
    final left = (offset.dx - labelWidth / 2)
        .clamp(16.0, math.max(16.0, width - labelWidth - 16))
        .toDouble();
    final rawTop = offset.dy > height * 0.36 ? offset.dy - 78 : offset.dy + 28;
    final top = rawTop.clamp(16.0, height - 96).toDouble();

    return Positioned(
      left: left,
      top: top,
      width: labelWidth,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          point.name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildStaticRouteMap() {
    final activeIndex = _safeSelectedHalte;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/maps_transjatim.png',
            width: double.infinity,
            height: 380,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 120,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                haltes[activeIndex],
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTileFallback() {
    return Container(
      color: const Color(0xffEDF3EE),
      child: CustomPaint(painter: _MapTileFallbackPainter()),
    );
  }
}

class _GeoPoint {
  const _GeoPoint(this.lat, this.lon, this.name);

  final double lat;
  final double lon;
  final String name;
}

class _RouteMapViewport {
  const _RouteMapViewport({
    required this.zoom,
    required this.centerX,
    required this.centerY,
    required this.width,
    required this.height,
  });

  final int zoom;
  final double centerX;
  final double centerY;
  final double width;
  final double height;

  static _RouteMapViewport fit({
    required List<_GeoPoint> points,
    required double width,
    required double height,
  }) {
    final validPoints = points.where((point) {
      return point.lat >= -85 &&
          point.lat <= 85 &&
          point.lon >= -180 &&
          point.lon <= 180;
    }).toList();

    if (validPoints.isEmpty) {
      return const _RouteMapViewport(
        zoom: 10,
        centerX: 0,
        centerY: 0,
        width: 0,
        height: 0,
      );
    }

    var zoom = 13;
    for (var candidate = 13; candidate >= 8; candidate--) {
      final bounds = _pixelBounds(validPoints, candidate);
      if (bounds.width <= width - 56 && bounds.height <= height - 56) {
        zoom = candidate;
        break;
      }
      zoom = candidate;
    }

    final bounds = _pixelBounds(validPoints, zoom);
    return _RouteMapViewport(
      zoom: zoom,
      centerX: (bounds.left + bounds.right) / 2,
      centerY: (bounds.top + bounds.bottom) / 2,
      width: width,
      height: height,
    );
  }

  Offset project(_GeoPoint point) {
    final pixel = _project(point, zoom);
    return Offset(
      pixel.dx - centerX + width / 2,
      pixel.dy - centerY + height / 2,
    );
  }

  static Rect _pixelBounds(List<_GeoPoint> points, int zoom) {
    final first = _project(points.first, zoom);
    var minX = first.dx;
    var maxX = first.dx;
    var minY = first.dy;
    var maxY = first.dy;

    for (final point in points.skip(1)) {
      final pixel = _project(point, zoom);
      minX = math.min(minX, pixel.dx);
      maxX = math.max(maxX, pixel.dx);
      minY = math.min(minY, pixel.dy);
      maxY = math.max(maxY, pixel.dy);
    }

    if ((maxX - minX).abs() < 1) {
      minX -= 1;
      maxX += 1;
    }
    if ((maxY - minY).abs() < 1) {
      minY -= 1;
      maxY += 1;
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  static Offset _project(_GeoPoint point, int zoom) {
    const tileSize = 256.0;
    final scale = math.pow(2, zoom) * tileSize;
    final lat = point.lat.clamp(-85.05112878, 85.05112878);
    final lon = point.lon.clamp(-180.0, 180.0);
    final latRad = lat * math.pi / 180;
    final x = (lon + 180) / 360 * scale;
    final y =
        (1 - math.log(math.tan(latRad) + 1 / math.cos(latRad)) / math.pi) /
        2 *
        scale;

    return Offset(x, y);
  }
}

class _TransjatimRoutePainter extends CustomPainter {
  const _TransjatimRoutePainter({
    required this.routePoints,
    required this.stopPoints,
    required this.activeIndex,
    required this.routeColor,
    required this.viewport,
  });

  final List<_GeoPoint> routePoints;
  final List<_GeoPoint> stopPoints;
  final int activeIndex;
  final Color routeColor;
  final _RouteMapViewport viewport;

  @override
  void paint(Canvas canvas, Size size) {
    if (routePoints.length > 1) {
      final routePath = Path()
        ..moveTo(
          viewport.project(routePoints.first).dx,
          viewport.project(routePoints.first).dy,
        );

      for (final point in routePoints.skip(1)) {
        final offset = viewport.project(point);
        routePath.lineTo(offset.dx, offset.dy);
      }

      canvas.drawPath(
        routePath,
        Paint()
          ..color = Colors.black.withValues(alpha: 0.46)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawPath(
        routePath,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
      canvas.drawPath(
        routePath,
        Paint()
          ..color = routeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }

    for (var index = 0; index < stopPoints.length; index++) {
      final isActive = index == activeIndex;
      final offset = viewport.project(stopPoints[index]);
      canvas.drawCircle(
        offset,
        isActive ? 9 : 7,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        offset,
        isActive ? 6.5 : 5,
        Paint()
          ..color = isActive ? routeColor : const Color(0xFF2E7D12)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TransjatimRoutePainter oldDelegate) {
    return oldDelegate.routePoints != routePoints ||
        oldDelegate.stopPoints != stopPoints ||
        oldDelegate.activeIndex != activeIndex ||
        oldDelegate.routeColor != routeColor ||
        oldDelegate.viewport != viewport;
  }
}

class _MapTileFallbackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.82)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    final waterPaint = Paint()
      ..color = const Color(0xffBCE9F5).withValues(alpha: 0.72)
      ..strokeWidth = 26
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height * 0.78),
      Offset(size.width, size.height * 0.58),
      waterPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.28),
      Offset(size.width, size.height * 0.48),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.18, 0),
      Offset(size.width * 0.72, size.height),
      roadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
