import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'auth_service.dart';

class KlinikHoaksException implements Exception {
  KlinikHoaksException(this.message);

  final String message;

  @override
  String toString() => message;
}

class KlinikHoaksRecap {
  const KlinikHoaksRecap({
    required this.hoaks,
    required this.disinformasi,
    required this.fakta,
    required this.hate,
  });

  final int hoaks;
  final int disinformasi;
  final int fakta;
  final int hate;
}

class KlinikHoaksArticle {
  const KlinikHoaksArticle({
    required this.image,
    required this.contentHtml,
    required this.title,
    required this.category,
    required this.slugPath,
    required this.publishedAt,
  });

  final String image;
  final String contentHtml;
  final String title;
  final String category;
  final String slugPath;
  final String publishedAt;

  String get slug => normalizeKlinikHoaksSlug(slugPath);
  String get contentText => stripKlinikHoaksHtml(contentHtml);
  String get formattedDate => formatKlinikHoaksDate(publishedAt);

  factory KlinikHoaksArticle.fromJson(Map<String, dynamic> json) {
    return KlinikHoaksArticle(
      image: resolveKlinikHoaksImageUrl(json['image']?.toString() ?? ''),
      contentHtml: json['isi']?.toString() ?? '',
      title: json['judul']?.toString() ?? '',
      category: json['kategori']?.toString() ?? '',
      slugPath: json['slug_path']?.toString() ?? '',
      publishedAt: json['tanggal']?.toString() ?? '',
    );
  }
}

class KlinikHoaksArticleDetail {
  const KlinikHoaksArticleDetail({
    required this.url,
    required this.slug,
    required this.title,
    required this.category,
    required this.publishedAt,
    required this.views,
    required this.contentHtml,
    required this.contentText,
    required this.referenceLinks,
    required this.imageUrl,
  });

  final String url;
  final String slug;
  final String title;
  final String category;
  final String publishedAt;
  final int views;
  final String contentHtml;
  final String contentText;
  final List<String> referenceLinks;
  final String imageUrl;

  String get formattedDate => formatKlinikHoaksDate(publishedAt);

  factory KlinikHoaksArticleDetail.fromJson(Map<String, dynamic> json) {
    final rawLinks = json['reference_links'];

    return KlinikHoaksArticleDetail(
      url: json['url']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      publishedAt: json['published_at']?.toString() ?? '',
      views: _toInt(json['views']),
      contentHtml: json['content_html']?.toString() ?? '',
      contentText:
          json['content_text']?.toString() ??
          stripKlinikHoaksHtml(json['content_html']?.toString() ?? ''),
      referenceLinks: rawLinks is List
          ? rawLinks
                .map((item) => item?.toString() ?? '')
                .where((item) => item.isNotEmpty)
                .toList()
          : const [],
      imageUrl: resolveKlinikHoaksImageUrl(json['image_url']?.toString() ?? ''),
    );
  }
}

class KlinikHoaksDashboard {
  const KlinikHoaksDashboard({
    required this.recap,
    required this.latestArticles,
  });

  final KlinikHoaksRecap recap;
  final List<KlinikHoaksArticle> latestArticles;
}

class KlinikHoaksService {
  KlinikHoaksService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  void dispose() {
    _client.close();
  }

  Future<KlinikHoaksDashboard> getDashboard() async {
    final results = await Future.wait([getRecap(), getKlarifikasiTerkini()]);

    return KlinikHoaksDashboard(
      recap: results[0] as KlinikHoaksRecap,
      latestArticles: results[1] as List<KlinikHoaksArticle>,
    );
  }

  Future<KlinikHoaksRecap> getRecap() async {
    final results = await Future.wait([
      _getCount('/klinik-hoaks/jumlah-hoaks-ytd', 'jmlhoaksytd'),
      _getCount('/klinik-hoaks/jumlah-disinformasi-ytd', 'jmldisinformasiytd'),
      _getCount('/klinik-hoaks/jumlah-fakta-ytd', 'jmlfaktaytd'),
      _getCount('/klinik-hoaks/jumlah-hate-ytd', 'jmlhateytd'),
    ]);

    return KlinikHoaksRecap(
      hoaks: results[0],
      disinformasi: results[1],
      fakta: results[2],
      hate: results[3],
    );
  }

  Future<List<KlinikHoaksArticle>> getKlarifikasiTerkini() async {
    final decoded = await _get('/klinik-hoaks/klarifikasi-terkini');
    final payload = _payloadMap(decoded);
    final data = payload['data'];

    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(KlinikHoaksArticle.fromJson)
        .where((item) => item.title.isNotEmpty)
        .toList();
  }

  Future<KlinikHoaksArticleDetail> getKlarifikasiDetail(String slug) async {
    final normalizedSlug = normalizeKlinikHoaksSlug(slug);
    if (normalizedSlug.isEmpty) {
      throw KlinikHoaksException('Slug klarifikasi tidak valid.');
    }

    final decoded = await _get(
      '/klinik-hoaks/klarifikasi/${Uri.encodeComponent(normalizedSlug)}',
    );
    final data = decoded['data'];

    if (data is Map<String, dynamic>) {
      return KlinikHoaksArticleDetail.fromJson(data);
    }

    throw KlinikHoaksException('Detail klarifikasi tidak ditemukan.');
  }

  Future<int> _getCount(String path, String key) async {
    final decoded = await _get(path);
    final payload = _payloadMap(decoded);
    final data = payload['data'];

    if (data is Map<String, dynamic>) {
      return _toInt(data[key]);
    }

    return 0;
  }

  Future<Map<String, dynamic>> _get(String path) async {
    http.Response response;

    try {
      response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: _headers(),
      );
    } catch (_) {
      throw KlinikHoaksException(
        'Tidak dapat terhubung ke server Klinik Hoaks.',
      );
    }

    final decoded = _decode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw KlinikHoaksException(
        decoded['error']?.toString() ??
            decoded['message']?.toString() ??
            'Gagal mengambil data Klinik Hoaks.',
      );
    }

    return decoded;
  }

  Map<String, String> _headers() {
    final headers = <String, String>{'Accept': 'application/json'};
    final session = AuthService.currentSession;
    if (session != null) {
      headers['Authorization'] = session.authorizationHeader;
    }
    return headers;
  }

  Map<String, dynamic> _decode(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}

    return {};
  }

  Map<String, dynamic> _payloadMap(Map<String, dynamic> decoded) {
    final data = decoded['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    return const {};
  }
}

String normalizeKlinikHoaksSlug(String input) {
  var value = input.trim();
  if (value.isEmpty) {
    return '';
  }

  final parsed = Uri.tryParse(value);
  if (parsed != null && parsed.hasAuthority) {
    value = parsed.path;
  }

  final queryIndex = value.indexOf('?');
  if (queryIndex >= 0) {
    value = value.substring(0, queryIndex);
  }

  final fragmentIndex = value.indexOf('#');
  if (fragmentIndex >= 0) {
    value = value.substring(0, fragmentIndex);
  }

  value = value.trim().replaceFirst(RegExp(r'^/+'), '');
  if (value.startsWith('post/')) {
    value = value.substring(5);
  }

  return value.replaceFirst(RegExp(r'/+$'), '').trim();
}

String resolveKlinikHoaksImageUrl(String rawUrl) {
  final value = rawUrl.trim();
  if (value.isEmpty) {
    return '';
  }

  if (value.startsWith('${ApiConfig.baseUrl}/klinik-hoaks/image')) {
    return value;
  }

  return Uri.parse(
    '${ApiConfig.baseUrl}/klinik-hoaks/image',
  ).replace(queryParameters: {'url': value}).toString();
}

String stripKlinikHoaksHtml(String html) {
  if (html.trim().isEmpty) {
    return '';
  }

  final withoutTags = html
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), ' ')
      .replaceAll(RegExp(r'</p\s*>', caseSensitive: false), ' ')
      .replaceAll(RegExp(r'<[^>]*>'), ' ');

  return _decodeHtmlEntities(
    withoutTags.replaceAll(RegExp(r'\s+'), ' ').trim(),
  );
}

String formatKlinikHoaksDate(String raw) {
  final parsed = _parseKlinikHoaksDate(raw);
  if (parsed == null) {
    return raw;
  }

  const monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  return '${parsed.day.toString().padLeft(2, '0')} '
      '${monthNames[parsed.month - 1]} ${parsed.year}';
}

DateTime? _parseKlinikHoaksDate(String raw) {
  final normalized = raw.trim().replaceFirst(' ', 'T');
  if (normalized.isEmpty) {
    return null;
  }

  return DateTime.tryParse(normalized);
}

String _decodeHtmlEntities(String value) {
  final namedEntities = <String, String>{
    '&nbsp;': ' ',
    '&amp;': '&',
    '&quot;': '"',
    '&#39;': "'",
    '&apos;': "'",
    '&lt;': '<',
    '&gt;': '>',
    '&ldquo;': '"',
    '&rdquo;': '"',
    '&lsquo;': "'",
    '&rsquo;': "'",
    '&ndash;': '-',
    '&mdash;': '-',
    '&hellip;': '...',
  };

  var decoded = value;
  for (final entry in namedEntities.entries) {
    decoded = decoded.replaceAll(entry.key, entry.value);
  }

  decoded = decoded.replaceAllMapped(RegExp(r'&#(\d+);'), (match) {
    final codePoint = int.tryParse(match.group(1) ?? '');
    return codePoint == null ? match.group(0)! : String.fromCharCode(codePoint);
  });

  decoded = decoded.replaceAllMapped(RegExp(r'&#x([0-9a-fA-F]+);'), (match) {
    final codePoint = int.tryParse(match.group(1) ?? '', radix: 16);
    return codePoint == null ? match.group(0)! : String.fromCharCode(codePoint);
  });

  return decoded;
}

int _toInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
