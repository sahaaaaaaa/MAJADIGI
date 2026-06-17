import 'package:flutter/material.dart';
import 'package:majadigi/features/klinik_hoax/data/klinik_hoaks_service.dart';
import 'package:majadigi/core/widgets/layanan_favorite_button.dart';
import 'package:majadigi/features/klinik_hoax/presentation/klinik_hoax_layanan_screen.dart';
import 'package:majadigi/features/klinik_hoax/presentation/klinik_hoax_detail_screen.dart';
import 'package:majadigi/features/klinik_hoax/presentation/klinik_hoax_info_screen.dart';

class KlinikHoaksHomeScreen extends StatefulWidget {
  const KlinikHoaksHomeScreen({super.key});

  @override
  State<KlinikHoaksHomeScreen> createState() => _KlinikHoaksHomeScreenState();
}

class _KlinikHoaksHomeScreenState extends State<KlinikHoaksHomeScreen> {
  late PageController _pageController;
  late final KlinikHoaksService _klinikHoaksService;
  int _activePage = 0;
  bool _isLoading = true;
  bool _showAllNews = false;
  String? _errorMessage;
  KlinikHoaksDashboard? _dashboard;

  List<KlinikHoaksArticle> get _featuredArticles {
    return (_dashboard?.latestArticles ?? const []).take(3).toList();
  }

  @override
  void initState() {
    super.initState();
    // 1. Slider mulai dari tengah (index 1000 agar infinite) dan viewportFraction 0.8
    _pageController = PageController(viewportFraction: 0.82, initialPage: 999);
    _klinikHoaksService = KlinikHoaksService();
    _loadDashboard();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _klinikHoaksService.dispose();
    super.dispose();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final dashboard = await _klinikHoaksService.getDashboard();
      if (!mounted) {
        return;
      }

      setState(() {
        _dashboard = dashboard;
        _isLoading = false;
      });
    } on KlinikHoaksException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = error.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Gagal memuat data Klinik Hoaks.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D57E7), // Warna dasar tema
      body: Stack(
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

          Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // 2. Slider dengan sudut membulat (ClipRRect)
                      _buildInfiniteSlider(),
                      const SizedBox(height: 15),
                      _buildPageIndicator(),
                      const SizedBox(height: 25),

                      // Container Putih Utama
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Layanan",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildLayananCard(
                                icon: Icons.volume_up_rounded,
                                title: "Laporan Hoaks",
                                desc:
                                    "Kirim info yang Kamu temukan, Kami bantu klarifikasi dalam 1x24 jam.",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const KlinikHoaksLayananScreen(
                                            initialTab: 0,
                                          ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildLayananCard(
                                icon: Icons.person_search_rounded,
                                title: "Lacak tiket Laporan",
                                desc:
                                    "Pantau status permohonan klarifikasi yang telah diajukan secara real time.",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const KlinikHoaksLayananScreen(
                                            initialTab: 1,
                                          ),
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 35),
                              const Text(
                                "Rekap Hoaks",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // 3. Ikon Rekap Hoaks diperbaiki
                              _buildRekapGrid(),

                              const SizedBox(height: 35),
                              const Text(
                                "Klarifikasi Terbaru",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              // 4. News List dengan Center Alignment
                              _buildNewsList(),

                              const SizedBox(height: 30),
                              // 5. Tombol Berita Lainnya diperbesar
                              _buildLargeMoreButton(),
                              const SizedBox(height: 50),
                            ],
                          ),
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
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Row(
              children: [
                Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                SizedBox(width: 8),
              ],
            ),
          ),
          const Text(
            "Klinik Hoaks",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              const LayananFavoriteButton(
                serviceName: 'Klinik Hoaks',
                lookupQuery: 'Klinik Hoaks',
              ),
              const SizedBox(width: 3),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const KlinikHoaksInformasiScreen(),
                    ),
                  );
                },
                child: Icon(
                  Icons.info_outline_rounded,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfiniteSlider() {
    final featuredArticles = _featuredArticles;
    final pageCount = featuredArticles.isEmpty ? 3 : featuredArticles.length;

    return SizedBox(
      height: 500, // Sesuaikan tinggi banner
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) =>
            setState(() => _activePage = index % pageCount),
        itemBuilder: (context, index) {
          final article = featuredArticles.isEmpty
              ? null
              : featuredArticles[index % featuredArticles.length];

          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: article == null
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  KlinikHoaksDetailScreen(article: article),
                            ),
                          );
                        },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      20,
                    ), // Membulat di ujung
                    child: article == null
                        ? _buildImagePlaceholder(
                            height: 500,
                            message: _isLoading
                                ? 'Memuat klarifikasi...'
                                : 'Gambar klarifikasi belum tersedia',
                          )
                        : _buildArticleImage(article.image, height: 500),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPageIndicator() {
    final pageCount = _featuredArticles.isEmpty ? 3 : _featuredArticles.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: _activePage == index ? 24 : 12,
          decoration: BoxDecoration(
            color: _activePage == index
                ? Colors.white
                : Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildLayananCard({
    required IconData icon,
    required String title,
    required String desc,
    required VoidCallback onTap, // Tambahkan parameter ini
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D57E7).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: const Color(0xFF0D57E7), size: 24),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap, // Gunakan parameter onTap di sini
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D57E7),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Selengkapnya",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRekapGrid() {
    final recap = _dashboard?.recap;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatCard(
          _statValue(recap?.hoaks),
          "Berita Hoaks",
          Icons.chat_bubble_rounded,
          Colors.brown,
        ),
        _buildStatCard(
          _statValue(recap?.disinformasi),
          "Disinformasi",
          Icons.campaign_rounded,
          Colors.orange,
        ),
        _buildStatCard(
          _statValue(recap?.fakta),
          "Fakta",
          Icons.check_circle_rounded,
          Colors.green,
        ),
        _buildStatCard(
          _statValue(recap?.hate),
          "Hate Speech",
          Icons.gavel_rounded,
          Colors.red,
        ),
      ],
    );
  }

  String _statValue(int? value) {
    if (_isLoading && value == null) {
      return "-";
    }

    return (value ?? 0).toString();
  }

  Widget _buildStatCard(String val, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                val,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Icon(icon, size: 18, color: color.withValues(alpha: 0.5)),
            ],
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
    if (_isLoading && _dashboard == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: CircularProgressIndicator(color: Color(0xFF0D57E7)),
        ),
      );
    }

    if (_errorMessage != null && _dashboard == null) {
      return _buildMessageCard(
        message: _errorMessage!,
        actionText: "Coba Lagi",
        onTap: _loadDashboard,
      );
    }

    final articles = _dashboard?.latestArticles ?? const [];
    if (articles.isEmpty) {
      return _buildMessageCard(message: "Belum ada klarifikasi terbaru.");
    }

    final visibleArticles = _showAllNews ? articles : articles.take(3).toList();

    return Column(
      children: visibleArticles
          .map(
            (article) => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => KlinikHoaksDetailScreen(article: article),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: _buildArticleImage(article.image, height: 180),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                article.formattedDate,
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 12,
                                ),
                              ),
                              _buildCategoryBadge(article.category),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildArticleImage(String imageUrl, {required double height}) {
    final normalizedUrl = resolveKlinikHoaksImageUrl(imageUrl).trim();

    if (normalizedUrl.isEmpty) {
      return _buildImagePlaceholder(
        height: height,
        message: 'Gambar klarifikasi belum tersedia',
      );
    }

    return Image.network(
      normalizedUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
      gaplessPlayback: true,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return _buildImagePlaceholder(
          height: height,
          message: 'Memuat gambar...',
          showProgress: true,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildImagePlaceholder(
          height: height,
          message: 'Gambar dari endpoint tidak dapat dimuat',
        );
      },
    );
  }

  Widget _buildImagePlaceholder({
    required double height,
    required String message,
    bool showProgress = false,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      color: const Color(0xFFEAF1FF),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showProgress)
            const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFF0D57E7),
              ),
            )
          else
            const Icon(
              Icons.image_not_supported_outlined,
              color: Color(0xFF0D57E7),
              size: 36,
            ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF31558F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    final color = _categoryColor(category);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        category.isEmpty ? "Klarifikasi" : category,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _categoryColor(String category) {
    final normalized = category.toLowerCase();
    if (normalized.contains('fakta')) {
      return Colors.green;
    }
    if (normalized.contains('disinformasi')) {
      return Colors.orange;
    }
    return Colors.red;
  }

  Widget _buildMessageCard({
    required String message,
    String? actionText,
    VoidCallback? onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, height: 1.4),
          ),
          if (actionText != null && onTap != null) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onTap, child: Text(actionText)),
          ],
        ],
      ),
    );
  }

  Widget _buildLargeMoreButton() {
    final articleCount = _dashboard?.latestArticles.length ?? 0;
    final canToggle = articleCount > 3;

    return SizedBox(
      width: double.infinity,
      height: 55, // Ukuran lebih besar sesuai referensi
      child: OutlinedButton(
        onPressed: canToggle
            ? () {
                setState(() {
                  _showAllNews = !_showAllNews;
                });
              }
            : null,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          _showAllNews ? "Tampilkan Lebih Sedikit" : "Berita Lainnya",
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
