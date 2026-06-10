import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:majadigi/screens/open_data/fitur_data_set.dart';
import 'package:majadigi/screens/open_data/fitur_detail_data_set.dart';
import 'package:majadigi/screens/open_data/open_data_dummy.dart';
import 'package:majadigi/services/open_data_service.dart';

class OpenDataCariDataScreen extends StatefulWidget {
  const OpenDataCariDataScreen({super.key});

  @override
  State<OpenDataCariDataScreen> createState() => _OpenDataCariDataScreenState();
}

class _OpenDataCariDataScreenState extends State<OpenDataCariDataScreen> {
  late final OpenDataService _openDataService;
  late final TextEditingController _searchController;
  late Future<_OpenDataSearchScreenData> _dashboardFuture;
  Timer? _searchDebounce;
  OpenDataSearchData? _searchData;
  bool _isSearching = false;
  String? _searchError;

  @override
  void initState() {
    super.initState();
    _openDataService = OpenDataService();
    _searchController = TextEditingController();
    _dashboardFuture = _loadDashboard();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _openDataService.dispose();
    super.dispose();
  }

  Future<_OpenDataSearchScreenData> _loadDashboard() async {
    final results = await Future.wait([
      _openDataService.getCount(),
      _openDataService.getVisitorStatistics(),
      _openDataService.getDownloadStatistics(),
      _openDataService.getTopics(),
      _openDataService.search(perPage: 5),
    ]);

    return _OpenDataSearchScreenData(
      count: results[0] as OpenDataCount,
      visitorStatistics: results[1] as OpenDataStatistics,
      downloadStatistics: results[2] as OpenDataStatistics,
      topics: (results[3] as OpenDataListResponse<OpenDataTopic>).items,
      searchData: results[4] as OpenDataSearchData,
    );
  }

  Future<void> _loadSearch() async {
    setState(() {
      _isSearching = true;
      _searchError = null;
    });

    try {
      final data = await _openDataService.search(
        query: _searchController.text,
        perPage: 5,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _searchData = data;
        _isSearching = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSearching = false;
        _searchError = "Pencarian belum dapat dimuat dari server.";
      });
    }
  }

  void _onSearchChanged(String _) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 450), _loadSearch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7),
      body: Stack(
        children: [
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
                          "Cari Data",
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
              const SizedBox(height: 20),
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
                  child: FutureBuilder<_OpenDataSearchScreenData>(
                    future: _dashboardFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF0D57E7),
                          ),
                        );
                      }

                      if (snapshot.hasError || !snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: _buildInfoBox(
                            "Data Open Data belum dapat dimuat.",
                          ),
                        );
                      }

                      final dashboard = snapshot.data!;
                      final searchData = _searchData ?? dashboard.searchData;

                      return _buildContent(dashboard, searchData);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    _OpenDataSearchScreenData dashboard,
    OpenDataSearchData searchData,
  ) {
    final highlights = searchData.results
        .where((item) => item.category.toLowerCase() == 'dataset')
        .map(_searchResultToHighlight)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBox(),
          const SizedBox(height: 20),
          _buildStatisticGrid(dashboard.count),
          const SizedBox(height: 28),
          const Text(
            "Grafik Pengunjung",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildChartCard(
            color: Colors.blue,
            statistics: dashboard.visitorStatistics,
          ),
          const SizedBox(height: 28),
          const Text(
            "Statistik Download",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildChartCard(
            color: Colors.green,
            statistics: dashboard.downloadStatistics,
          ),
          const SizedBox(height: 30),
          const Text(
            "Telusuri Data Berdasarkan Topik",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 18),
          _buildTopicList(dashboard.topics),
          const SizedBox(height: 30),
          const Text(
            "Highlight Data",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (_searchError != null) ...[
            _buildInfoBox(_searchError!),
            const SizedBox(height: 16),
          ],
          if (_isSearching)
            _buildLoadingBox()
          else if (highlights.isEmpty)
            _buildInfoBox("Data tidak ditemukan.")
          else
            Column(
              children: highlights.map((item) {
                return _buildHighlightCard(
                  title: item.title,
                  instansi: item.instansi,
                  tahun: item.tahun,
                  kategori: item.kategori,
                  tanggal: item.tanggal,
                  status: item.status,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FiturDetailDataSetScreen(item: item),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
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
              onSubmitted: (_) => _loadSearch(),
              decoration: InputDecoration(
                hintText: "Cari Data dan Informasi",
                hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticGrid(OpenDataCount data) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.45,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      children: [
        _buildStatCard(
          title: formatOpenDataNumber(data.totalDataset),
          subtitle: "Dataset",
          color: Colors.blue,
          icon: Icons.dataset_outlined,
        ),
        _buildStatCard(
          title: formatOpenDataNumber(data.totalOrganization),
          subtitle: "Perangkat Daerah",
          color: Colors.purple,
          icon: Icons.groups_outlined,
        ),
        _buildStatCard(
          title: formatOpenDataNumber(data.totalArticle),
          subtitle: "Artikel",
          color: Colors.green,
          icon: Icons.trending_up,
        ),
        _buildStatCard(
          title: formatOpenDataNumber(data.totalVisitor),
          subtitle: "Pengunjung",
          color: Colors.orange,
          icon: Icons.remove_red_eye_outlined,
        ),
        _buildStatCard(
          title: formatOpenDataNumber(data.totalInfographic),
          subtitle: "Infografik",
          color: Colors.red,
          icon: Icons.image_outlined,
        ),
        _buildStatCard(
          title: formatOpenDataNumber(data.totalPublication),
          subtitle: "Publikasi",
          color: Colors.indigo,
          icon: Icons.menu_book_outlined,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(icon, color: color, size: 18),
            ],
          ),
          const Spacer(),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey[700], fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({
    required Color color,
    required OpenDataStatistics statistics,
  }) {
    final values = statistics.data
        .map((item) => item.value.toDouble())
        .toList();
    final maxValue = values.isEmpty ? 0 : values.reduce(math.max);
    final axisMax = maxValue <= 0 ? 1.0 : maxValue;

    return Container(
      height: 260,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    5,
                    (index) =>
                        Container(height: 1, color: Colors.grey.shade200),
                  ),
                ),
                CustomPaint(
                  size: const Size(double.infinity, 180),
                  painter: ModernChartPainter(color, values),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(5, (index) {
                        final value = axisMax - (axisMax / 4 * index);
                        return _buildYLabel(_compactNumber(value));
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Jan"),
                Text("Apr"),
                Text("Jul"),
                Text("Okt"),
                Text("Des"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYLabel(String text) {
    return Text(text, style: TextStyle(color: Colors.grey[500], fontSize: 11));
  }

  Widget _buildTopicList(List<OpenDataTopic> topics) {
    final items = topics.isEmpty
        ? [
            const OpenDataTopic(
              id: 0,
              name: "Ekonomi",
              slug: "ekonomi",
              image: "",
              publicDatasetCount: 0,
            ),
            const OpenDataTopic(
              id: 0,
              name: "Kesehatan",
              slug: "kesehatan",
              image: "",
              publicDatasetCount: 0,
            ),
          ]
        : topics;

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return _buildTopicItem(
            title: item.name,
            imagePath: item.localImagePath,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FiturDataSetScreen(selectedKategori: item.name),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTopicItem({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F6FA),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightCard({
    required String title,
    required String instansi,
    required String tahun,
    required String kategori,
    required String tanggal,
    required String status,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.withOpacity(0.12),
                  child: const Icon(Icons.apartment, color: Colors.blue),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              instansi,
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  tahun,
                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                ),
                const SizedBox(width: 20),
                Icon(
                  Icons.grid_view_rounded,
                  size: 14,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    kategori,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
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
                const SizedBox(width: 20),
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

  HighlightDataModel _searchResultToHighlight(OpenDataSearchResult item) {
    return HighlightDataModel(
      title: item.name,
      instansi: item.organizationName.isEmpty ? '-' : item.organizationName,
      tahun: item.dimension.isEmpty ? '-' : item.dimension,
      kategori: item.topicName.isEmpty ? item.category : item.topicName,
      tanggal: formatOpenDataDate(item.updatedAt),
      status: item.status.isEmpty ? '-' : item.status,
      slug: item.slug,
      organisasiImage: item.topicImage,
      description: stripHtml(item.description),
      countView: item.viewCount,
      countDownload: item.downloadCount,
    );
  }
}

class ModernChartPainter extends CustomPainter {
  ModernChartPainter(this.color, this.values);

  final Color color;
  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) {
      return;
    }

    final maxValue = values.reduce(math.max);
    final safeMax = maxValue <= 0 ? 1 : maxValue;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.10)
      ..style = PaintingStyle.fill;

    final path = Path();
    final horizontalStep = values.length == 1
        ? size.width
        : (size.width - 40) / (values.length - 1);

    for (var i = 0; i < values.length; i++) {
      final x = 30 + (horizontalStep * i);
      final y = 20 + ((safeMax - values[i]) / safeMax * (size.height - 40));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width - 10, size.height)
      ..lineTo(30, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant ModernChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}

class _OpenDataSearchScreenData {
  const _OpenDataSearchScreenData({
    required this.count,
    required this.visitorStatistics,
    required this.downloadStatistics,
    required this.topics,
    required this.searchData,
  });

  final OpenDataCount count;
  final OpenDataStatistics visitorStatistics;
  final OpenDataStatistics downloadStatistics;
  final List<OpenDataTopic> topics;
  final OpenDataSearchData searchData;
}

String _compactNumber(num value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}Jt';
  }
  if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(0)}K';
  }
  return value.round().toString();
}
