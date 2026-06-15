import 'package:flutter/material.dart';

import 'package:majadigi/features/klinik_hoax/data/klinik_hoaks_service.dart';

class KlinikHoaksDetailScreen extends StatefulWidget {
  const KlinikHoaksDetailScreen({super.key, this.article, this.slug});

  final KlinikHoaksArticle? article;
  final String? slug;

  @override
  State<KlinikHoaksDetailScreen> createState() =>
      _KlinikHoaksDetailScreenState();
}

class _KlinikHoaksDetailScreenState extends State<KlinikHoaksDetailScreen> {
  late final KlinikHoaksService _klinikHoaksService;
  KlinikHoaksArticleDetail? _detail;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _klinikHoaksService = KlinikHoaksService();
    _loadDetail();
  }

  @override
  void dispose() {
    _klinikHoaksService.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    final slug = widget.slug ?? widget.article?.slug ?? '';
    if (slug.trim().isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Slug klarifikasi tidak ditemukan.';
      });
      return;
    }

    try {
      final detail = await _klinikHoaksService.getKlarifikasiDetail(slug);
      if (!mounted) {
        return;
      }

      setState(() {
        _detail = detail;
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
        _errorMessage = 'Gagal memuat detail klarifikasi.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;
    final imageUrl = _firstNonEmpty([article?.image, _detail?.imageUrl]);
    final title = _firstNonEmpty([
      _detail?.title,
      article?.title,
      'Klarifikasi Hoaks',
    ]);
    final category = _firstNonEmpty([
      _detail?.category,
      article?.category,
      'Klarifikasi',
    ]);
    final publishedAt = _firstNonEmpty([
      _detail?.formattedDate,
      article?.formattedDate,
      '-',
    ]);
    final content = _firstNonEmpty([
      _detail?.contentText,
      article?.contentText,
      'Memuat klarifikasi...',
    ]);

    return Scaffold(
      // Menggunakan warna biru sebagai background dasar agar saat scroll tidak putih di atas
      backgroundColor: const Color(0xFF0D57E7),
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE/COLOR (Paling Bawah)
          Container(
            width: double.infinity,
            height: 300, // Tinggi area biru
            decoration: const BoxDecoration(
              color: Color(0xFF0D57E7), // Warna fallback
              image: DecorationImage(
                image: AssetImage('assets/images/latar_belakang.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          // 2. KONTEN UTAMA (Header + Scrollable White Area)
          Column(
            children: [
              const SizedBox(height: 10),

              // HEADER (Tombol Kembali)
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: const Text(
                      "Kembali",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white, // Efek warna saat ditekan
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // AREA PUTIH (Menggunakan Expanded agar mengisi sisa layar)
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // GAMBAR BANNER (Sesuai gambar di HP)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: _buildArticleImage(imageUrl),
                        ),

                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: LinearProgressIndicator(
                              color: Color(0xFF0D57E7),
                              minHeight: 3,
                            ),
                          ),

                        const SizedBox(height: 20),

                        // TANGGAL & LABEL HOAKS
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              publishedAt,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const Spacer(),
                            _buildCategoryBadge(category),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // JUDUL
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 16),

                        if (_errorMessage != null && _detail == null)
                          _buildErrorMessage(content)
                        else
                          Text(
                            content,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.6,
                              color: Colors.grey[800],
                            ),
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

  Widget _buildArticleImage(String imageUrl) {
    final normalizedUrl = resolveKlinikHoaksImageUrl(imageUrl).trim();

    if (normalizedUrl.isEmpty) {
      return _buildImagePlaceholder('Gambar klarifikasi belum tersedia');
    }

    return Image.network(
      normalizedUrl,
      width: double.infinity,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
      gaplessPlayback: true,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return _buildImagePlaceholder('Memuat gambar...', showProgress: true);
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildImagePlaceholder(
          'Gambar dari endpoint tidak dapat dimuat',
        );
      },
    );
  }

  Widget _buildImagePlaceholder(String message, {bool showProgress = false}) {
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Container(
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
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    final color = _categoryColor(category);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        category.isEmpty ? "Klarifikasi" : category,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildErrorMessage(String fallbackContent) {
    final hasFallback = widget.article?.contentText.isNotEmpty == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF4F4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFFD6D6)),
          ),
          child: Text(
            hasFallback
                ? 'Detail lengkap belum dapat dimuat. Menampilkan ringkasan dari daftar klarifikasi.'
                : _errorMessage!,
            style: const TextStyle(color: Color(0xFFB3261E), height: 1.4),
          ),
        ),
        if (hasFallback) ...[
          const SizedBox(height: 16),
          Text(
            fallbackContent,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.grey[800],
            ),
          ),
        ],
      ],
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

  String _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final normalized = value?.trim() ?? '';
      if (normalized.isNotEmpty) {
        return normalized;
      }
    }

    return '';
  }
}
