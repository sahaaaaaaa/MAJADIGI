import 'package:flutter/material.dart';
import 'package:majadigi/services/open_data_service.dart';

class OpenDataDetailScreen extends StatefulWidget {
  final OpenDataInfographic infographic;

  const OpenDataDetailScreen({super.key, required this.infographic});

  @override
  State<OpenDataDetailScreen> createState() => _OpenDataDetailScreenState();
}

class _OpenDataDetailScreenState extends State<OpenDataDetailScreen> {
  late final OpenDataService _openDataService;
  late Future<OpenDataInfographic> _detailFuture;

  @override
  void initState() {
    super.initState();
    _openDataService = OpenDataService();
    _detailFuture = _loadDetail();
  }

  @override
  void dispose() {
    _openDataService.dispose();
    super.dispose();
  }

  Future<OpenDataInfographic> _loadDetail() async {
    if (widget.infographic.slug.isEmpty) {
      return widget.infographic;
    }

    try {
      return await _openDataService.getInfographicDetail(
        widget.infographic.slug,
      );
    } catch (_) {
      return widget.infographic;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/latar_belakang.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 55, 16, 0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Kembali",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<OpenDataInfographic>(
                  future: _detailFuture,
                  builder: (context, snapshot) {
                    final data = snapshot.data ?? widget.infographic;

                    return Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: _buildImage(data.primaryImage),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  formatOpenDataDate(data.releaseDate),
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.blue),
                                  ),
                                  child: Text(
                                    data.topicName.isEmpty
                                        ? "Infografis"
                                        : data.topicName,
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              data.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              stripHtml(data.description),
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 16,
                                height: 1.8,
                              ),
                            ),
                            if (data.images.length > 1) ...[
                              const SizedBox(height: 24),
                              _buildImageStrip(data.images),
                            ],
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D57E7),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  "Unduh",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    final imageUrl = resolveOpenDataAssetUrl(imagePath);
    if (imageUrl.isEmpty) {
      return Image.asset(
        'assets/images/openData/open_data_banner1.png',
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      imageUrl,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/images/openData/open_data_banner1.png',
          width: double.infinity,
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildImageStrip(List<String> images) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 92,
              height: 92,
              child: _buildImage(images[index]),
            ),
          );
        },
      ),
    );
  }
}
