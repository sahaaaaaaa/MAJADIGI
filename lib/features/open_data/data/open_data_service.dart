import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:majadigi/core/services/api_config.dart';
import 'package:majadigi/features/auth/data/auth_service.dart';

class OpenDataException implements Exception {
  OpenDataException(this.message);

  final String message;

  @override
  String toString() => message;
}

class OpenDataCount {
  const OpenDataCount({
    required this.totalArticle,
    required this.totalArticleThisYear,
    required this.totalDataset,
    required this.totalDatasetThisYear,
    required this.totalDownload,
    required this.totalInfographic,
    required this.totalInfographicThisYear,
    required this.totalOrganization,
    required this.totalPublication,
    required this.totalPublicationThisYear,
    required this.totalVisitor,
    required this.totalVisitorThisYear,
  });

  final int totalArticle;
  final int totalArticleThisYear;
  final int totalDataset;
  final int totalDatasetThisYear;
  final int totalDownload;
  final int totalInfographic;
  final int totalInfographicThisYear;
  final int totalOrganization;
  final int totalPublication;
  final int totalPublicationThisYear;
  final int totalVisitor;
  final int totalVisitorThisYear;

  factory OpenDataCount.empty() {
    return const OpenDataCount(
      totalArticle: 0,
      totalArticleThisYear: 0,
      totalDataset: 0,
      totalDatasetThisYear: 0,
      totalDownload: 0,
      totalInfographic: 0,
      totalInfographicThisYear: 0,
      totalOrganization: 0,
      totalPublication: 0,
      totalPublicationThisYear: 0,
      totalVisitor: 0,
      totalVisitorThisYear: 0,
    );
  }

  factory OpenDataCount.fromJson(Map<String, dynamic> json) {
    return OpenDataCount(
      totalArticle: _toInt(json['total_article']),
      totalArticleThisYear: _toInt(json['total_article_this_year']),
      totalDataset: _toInt(json['total_dataset']),
      totalDatasetThisYear: _toInt(json['total_dataset_this_year']),
      totalDownload: _toInt(json['total_download']),
      totalInfographic: _toInt(json['total_infographic']),
      totalInfographicThisYear: _toInt(json['total_infographic_this_year']),
      totalOrganization: _toInt(json['total_organization']),
      totalPublication: _toInt(json['total_publication']),
      totalPublicationThisYear: _toInt(json['total_publication_this_year']),
      totalVisitor: _toInt(json['total_visitor']),
      totalVisitorThisYear: _toInt(json['total_visitor_this_year']),
    );
  }
}

class OpenDataMonthlyStat {
  const OpenDataMonthlyStat({
    required this.month,
    required this.monthName,
    required this.value,
  });

  final int month;
  final String monthName;
  final int value;

  factory OpenDataMonthlyStat.fromJson(
    Map<String, dynamic> json,
    String valueKey,
  ) {
    return OpenDataMonthlyStat(
      month: _toInt(json['month']),
      monthName: json['month_name']?.toString() ?? '',
      value: _toInt(json[valueKey]),
    );
  }
}

class OpenDataStatistics {
  const OpenDataStatistics({
    required this.data,
    required this.total,
    required this.year,
  });

  final List<OpenDataMonthlyStat> data;
  final int total;
  final int year;

  factory OpenDataStatistics.fromJson(
    Map<String, dynamic> json,
    String valueKey,
  ) {
    final rawData = json['data'];

    return OpenDataStatistics(
      data: rawData is List
          ? rawData
                .whereType<Map<String, dynamic>>()
                .map((item) => OpenDataMonthlyStat.fromJson(item, valueKey))
                .toList()
          : const [],
      total: _toInt(json['total']),
      year: _toInt(json['year']),
    );
  }
}

class OpenDataTopic {
  const OpenDataTopic({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.publicDatasetCount,
  });

  final int id;
  final String name;
  final String slug;
  final String image;
  final int publicDatasetCount;

  String get localImagePath => topicAssetPath(name);

  factory OpenDataTopic.fromJson(Map<String, dynamic> json) {
    return OpenDataTopic(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      publicDatasetCount: _toInt(json['count_dataset_public']),
    );
  }
}

class OpenDataOrganization {
  const OpenDataOrganization({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.publicDatasetCount,
  });

  final int id;
  final String name;
  final String slug;
  final String image;
  final int publicDatasetCount;

  factory OpenDataOrganization.fromJson(Map<String, dynamic> json) {
    return OpenDataOrganization(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      publicDatasetCount: _toInt(json['count_dataset_public']),
    );
  }
}

class OpenDataDataset {
  const OpenDataDataset({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.organizationName,
    required this.organizationSlug,
    required this.organizationImage,
    required this.topicName,
    required this.topicSlug,
    required this.topicImage,
    required this.dimension,
    required this.period,
    required this.status,
    required this.updatedAt,
    required this.schema,
    required this.table,
    required this.viewCount,
    required this.downloadCount,
    this.periodUpdates = const [],
  });

  final int id;
  final String name;
  final String slug;
  final String description;
  final String organizationName;
  final String organizationSlug;
  final String organizationImage;
  final String topicName;
  final String topicSlug;
  final String topicImage;
  final String dimension;
  final String period;
  final String status;
  final String updatedAt;
  final String schema;
  final String table;
  final int viewCount;
  final int downloadCount;
  final List<OpenDataPeriodUpdate> periodUpdates;

  factory OpenDataDataset.fromJson(Map<String, dynamic> json) {
    final rawPeriodUpdates = json['periode_update'];

    return OpenDataDataset(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['deskripsi']?.toString() ?? '',
      organizationName:
          json['organisasi_name']?.toString() ??
          json['organization_name']?.toString() ??
          '',
      organizationSlug:
          json['organisasi_slug']?.toString() ??
          json['organization_slug']?.toString() ??
          '',
      organizationImage: json['organisasi_image']?.toString() ?? '',
      topicName:
          json['topik_name']?.toString() ??
          json['topic_name']?.toString() ??
          '',
      topicSlug:
          json['topik_slug']?.toString() ??
          json['topic_slug']?.toString() ??
          '',
      topicImage:
          json['topik_image']?.toString() ??
          json['topic_image']?.toString() ??
          '',
      dimension: json['dimension']?.toString() ?? _dimensionFromMetadata(json),
      period: json['periode']?.toString() ?? '',
      status:
          json['data_tetap']?.toString() ??
          json['status']?.toString() ??
          json['validate']?.toString() ??
          '',
      updatedAt: json['mdate']?.toString() ?? json['cdate']?.toString() ?? '',
      schema: json['schema']?.toString() ?? '',
      table: json['table']?.toString() ?? '',
      viewCount: _toInt(
        json['count_view_opendata'] ??
            json['count_view'] ??
            json['count_view_satudata'],
      ),
      downloadCount: _toInt(
        json['count_download_opendata'] ?? json['count_download'],
      ),
      periodUpdates: rawPeriodUpdates is List
          ? rawPeriodUpdates
                .whereType<Map<String, dynamic>>()
                .map(OpenDataPeriodUpdate.fromJson)
                .where((item) => item.label.isNotEmpty)
                .toList()
          : const [],
    );
  }
}

class OpenDataPeriodUpdate {
  const OpenDataPeriodUpdate({
    required this.id,
    required this.label,
    required this.labelFormat,
    required this.status,
  });

  final int id;
  final String label;
  final String labelFormat;
  final String status;

  factory OpenDataPeriodUpdate.fromJson(Map<String, dynamic> json) {
    return OpenDataPeriodUpdate(
      id: _toInt(json['id']),
      label:
          json['periode_label']?.toString() ?? json['label']?.toString() ?? '',
      labelFormat: json['periode_label_format']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
    );
  }
}

class OpenDataInfographic {
  const OpenDataInfographic({
    required this.name,
    required this.slug,
    required this.description,
    required this.thumbnail,
    required this.images,
    required this.topicName,
    required this.organizationName,
    required this.releaseDate,
    required this.viewCount,
    required this.downloadCount,
  });

  final String name;
  final String slug;
  final String description;
  final String thumbnail;
  final List<String> images;
  final String topicName;
  final String organizationName;
  final String releaseDate;
  final int viewCount;
  final int downloadCount;

  String get primaryImage {
    if (thumbnail.isNotEmpty) {
      return thumbnail;
    }
    return images.isNotEmpty ? images.first : '';
  }

  factory OpenDataInfographic.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    final topic = json['topic'];
    final organization = json['organization'];

    return OpenDataInfographic(
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      images: rawImages is List
          ? rawImages
                .whereType<Map<String, dynamic>>()
                .map((item) => item['image']?.toString() ?? '')
                .where((item) => item.isNotEmpty)
                .toList()
          : const [],
      topicName: topic is Map<String, dynamic>
          ? topic['name']?.toString() ?? ''
          : json['topic_name']?.toString() ?? '',
      organizationName: organization is Map<String, dynamic>
          ? organization['name']?.toString() ?? ''
          : json['organization_name']?.toString() ?? '',
      releaseDate:
          json['release_date']?.toString() ?? json['mdate']?.toString() ?? '',
      viewCount: _toInt(json['count_view']),
      downloadCount: _toInt(json['count_download']),
    );
  }
}

class OpenDataSearchData {
  const OpenDataSearchData({
    required this.counts,
    required this.results,
    required this.pagination,
  });

  final OpenDataSearchCount counts;
  final List<OpenDataSearchResult> results;
  final OpenDataPagination pagination;

  factory OpenDataSearchData.fromJson(Map<String, dynamic> json) {
    final rawResults = json['data'];

    return OpenDataSearchData(
      counts: OpenDataSearchCount.fromJson(
        json['count'] is Map<String, dynamic>
            ? json['count'] as Map<String, dynamic>
            : const {},
      ),
      results: rawResults is List
          ? rawResults
                .whereType<Map<String, dynamic>>()
                .map(OpenDataSearchResult.fromJson)
                .toList()
          : const [],
      pagination: OpenDataPagination.fromJson(
        json['pagination'] is Map<String, dynamic>
            ? json['pagination'] as Map<String, dynamic>
            : const {},
      ),
    );
  }
}

class OpenDataSearchCount {
  const OpenDataSearchCount({
    required this.total,
    required this.dataset,
    required this.infographic,
    required this.article,
    required this.organization,
    required this.publication,
  });

  final int total;
  final int dataset;
  final int infographic;
  final int article;
  final int organization;
  final int publication;

  factory OpenDataSearchCount.fromJson(Map<String, dynamic> json) {
    return OpenDataSearchCount(
      total: _toInt(json['total']),
      dataset: _toInt(json['dataset']),
      infographic: _toInt(json['infographic']),
      article: _toInt(json['article']),
      organization: _toInt(json['organization']),
      publication: _toInt(json['publication']),
    );
  }
}

class OpenDataSearchResult {
  const OpenDataSearchResult({
    required this.category,
    required this.name,
    required this.slug,
    required this.description,
    required this.organizationName,
    required this.organizationSlug,
    required this.topicName,
    required this.topicSlug,
    required this.topicImage,
    required this.dimension,
    required this.updatedAt,
    required this.status,
    required this.thumbnail,
    required this.viewCount,
    required this.downloadCount,
  });

  final String category;
  final String name;
  final String slug;
  final String description;
  final String organizationName;
  final String organizationSlug;
  final String topicName;
  final String topicSlug;
  final String topicImage;
  final String dimension;
  final String updatedAt;
  final String status;
  final String thumbnail;
  final int viewCount;
  final int downloadCount;

  factory OpenDataSearchResult.fromJson(Map<String, dynamic> json) {
    return OpenDataSearchResult(
      category: json['category']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      organizationName: json['organization_name']?.toString() ?? '',
      organizationSlug: json['organization_slug']?.toString() ?? '',
      topicName: json['topic_name']?.toString() ?? '',
      topicSlug: json['topic_slug']?.toString() ?? '',
      topicImage: json['topic_image']?.toString() ?? '',
      dimension: json['dimension']?.toString() ?? '',
      updatedAt: json['mdate']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      viewCount: _toInt(json['count_view_opendata'] ?? json['count_view']),
      downloadCount: _toInt(json['count_download']),
    );
  }
}

class OpenDataListResponse<T> {
  const OpenDataListResponse({required this.items, required this.pagination});

  final List<T> items;
  final OpenDataPagination pagination;
}

class OpenDataPagination {
  const OpenDataPagination({
    required this.page,
    required this.perPage,
    required this.totalData,
    required this.totalPage,
    required this.hasNext,
    required this.hasPrevious,
  });

  final int page;
  final int perPage;
  final int totalData;
  final int totalPage;
  final bool hasNext;
  final bool hasPrevious;

  factory OpenDataPagination.fromJson(Map<String, dynamic> json) {
    return OpenDataPagination(
      page: _toInt(json['page']),
      perPage: _toInt(json['per_page']),
      totalData: _toInt(json['total_data']),
      totalPage: _toInt(json['total_page']),
      hasNext: json['has_next'] == true,
      hasPrevious: json['has_previous'] == true,
    );
  }
}

class OpenDataCleanedBigData {
  const OpenDataCleanedBigData({
    required this.rows,
    required this.metadata,
    required this.metadataFilter,
    required this.pagination,
  });

  final List<Map<String, dynamic>> rows;
  final List<String> metadata;
  final Map<String, List<String>> metadataFilter;
  final OpenDataPagination pagination;

  factory OpenDataCleanedBigData.fromJson(Map<String, dynamic> json) {
    final rawRows = json['data'];
    final rawMetadata = json['metadata'];
    final rawFilter = json['metadata_filter'];

    final filters = <String, List<String>>{};
    if (rawFilter is List) {
      for (final item in rawFilter.whereType<Map<String, dynamic>>()) {
        final key = item['key']?.toString() ?? '';
        final value = item['value'];
        if (key.isNotEmpty && value is List) {
          filters[key] = value.map((item) => item.toString()).toList();
        }
      }
    }

    return OpenDataCleanedBigData(
      rows: rawRows is List
          ? rawRows.whereType<Map<String, dynamic>>().toList()
          : const [],
      metadata: rawMetadata is List
          ? rawMetadata.map((item) => item.toString()).toList()
          : const [],
      metadataFilter: filters,
      pagination: OpenDataPagination.fromJson(
        json['pagination'] is Map<String, dynamic>
            ? json['pagination'] as Map<String, dynamic>
            : const {},
      ),
    );
  }
}

class OpenDataService {
  OpenDataService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  void dispose() {
    _client.close();
  }

  Future<OpenDataCount> getCount() async {
    final decoded = await _get('/open-data/count');
    return OpenDataCount.fromJson(_payloadMap(decoded));
  }

  Future<OpenDataStatistics> getVisitorStatistics({int? year}) async {
    final decoded = await _get(
      '/open-data/visitor-statistics',
      queryParameters: year == null ? const {} : {'year': year.toString()},
    );
    return OpenDataStatistics.fromJson(_payloadMap(decoded), 'total_visitor');
  }

  Future<OpenDataStatistics> getDownloadStatistics({int? year}) async {
    final decoded = await _get(
      '/open-data/download-statistics',
      queryParameters: year == null ? const {} : {'year': year.toString()},
    );
    return OpenDataStatistics.fromJson(_payloadMap(decoded), 'total_download');
  }

  Future<OpenDataListResponse<OpenDataTopic>> getTopics() async {
    final decoded = await _get('/open-data/topik');
    final payload = _payloadMap(decoded);

    return OpenDataListResponse(
      items: _payloadList(payload)
          .whereType<Map<String, dynamic>>()
          .map(OpenDataTopic.fromJson)
          .where((item) => item.name.isNotEmpty)
          .toList(),
      pagination: _pagination(payload),
    );
  }

  Future<OpenDataListResponse<OpenDataOrganization>> getOrganizations() async {
    final decoded = await _get('/open-data/organisasi');
    final payload = _payloadMap(decoded);

    return OpenDataListResponse(
      items: _payloadList(payload)
          .whereType<Map<String, dynamic>>()
          .map(OpenDataOrganization.fromJson)
          .where((item) => item.name.isNotEmpty)
          .toList(),
      pagination: _pagination(payload),
    );
  }

  Future<OpenDataListResponse<OpenDataDataset>> getDatasets({
    String search = '',
    int page = 1,
    int perPage = 10,
    String where = '',
  }) async {
    final queryParameters = <String, String>{
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (search.trim().isNotEmpty) {
      queryParameters['search'] = search.trim();
    }
    if (where.trim().isNotEmpty) {
      queryParameters['where'] = where.trim();
    }

    final decoded = await _get(
      '/open-data/datasets',
      queryParameters: queryParameters,
    );
    final payload = _payloadMap(decoded);

    return OpenDataListResponse(
      items: _payloadList(payload)
          .whereType<Map<String, dynamic>>()
          .map(OpenDataDataset.fromJson)
          .where((item) => item.name.isNotEmpty)
          .toList(),
      pagination: _pagination(payload),
    );
  }

  Future<OpenDataDataset> getDatasetDetail(String slug) async {
    final decoded = await _get('/open-data/datasets/$slug');
    return OpenDataDataset.fromJson(_payloadMap(_payloadMap(decoded)));
  }

  Future<OpenDataListResponse<OpenDataInfographic>> getInfographics({
    int page = 1,
    int perPage = 4,
  }) async {
    final decoded = await _get(
      '/open-data/infographic',
      queryParameters: {
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );
    final payload = _payloadMap(decoded);

    return OpenDataListResponse(
      items: _payloadList(payload)
          .whereType<Map<String, dynamic>>()
          .map(OpenDataInfographic.fromJson)
          .where((item) => item.name.isNotEmpty)
          .toList(),
      pagination: _pagination(payload),
    );
  }

  Future<OpenDataInfographic> getInfographicDetail(String slug) async {
    final decoded = await _get('/open-data/infographic/$slug');
    return OpenDataInfographic.fromJson(_payloadMap(_payloadMap(decoded)));
  }

  Future<OpenDataSearchData> search({
    String query = '',
    int page = 1,
    int perPage = 5,
  }) async {
    final decoded = await _get(
      '/open-data/search',
      queryParameters: {
        'q': query.trim(),
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
    );
    return OpenDataSearchData.fromJson(_payloadMap(_payloadMap(decoded)));
  }

  Future<OpenDataCleanedBigData> getCleanedBigDataAuto({
    required String schema,
    required String table,
  }) async {
    final decoded = await _get(
      '/open-data/cleaned-bigdata/auto/$schema/$table',
    );
    return OpenDataCleanedBigData.fromJson(_payloadMap(decoded));
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, String> queryParameters = const {},
  }) async {
    http.Response response;

    try {
      response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}$path').replace(
          queryParameters: queryParameters.isEmpty ? null : queryParameters,
        ),
        headers: _headers(),
      );
    } catch (_) {
      throw OpenDataException('Tidak dapat terhubung ke server Open Data.');
    }

    final decoded = _decode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw OpenDataException(
        decoded['error']?.toString() ??
            decoded['message']?.toString() ??
            'Gagal mengambil data Open Data.',
      );
    }

    return decoded;
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

  Map<String, String> _headers() {
    final headers = <String, String>{'Accept': 'application/json'};
    final session = AuthService.currentSession;
    if (session != null) {
      headers['Authorization'] = session.authorizationHeader;
    }
    return headers;
  }

  Map<String, dynamic> _payloadMap(Map<String, dynamic> decoded) {
    final data = decoded['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    return decoded;
  }

  List<dynamic> _payloadList(Map<String, dynamic> payload) {
    final data = payload['data'];
    return data is List ? data : const [];
  }

  OpenDataPagination _pagination(Map<String, dynamic> payload) {
    final pagination = payload['pagination'];
    return OpenDataPagination.fromJson(
      pagination is Map<String, dynamic> ? pagination : const {},
    );
  }
}

String resolveOpenDataAssetUrl(String path) {
  final value = path.trim();
  if (value.isEmpty) {
    return '';
  }
  if (value.startsWith('http://') || value.startsWith('https://')) {
    return value;
  }
  return 'https://opendata.jatimprov.go.id/${value.replaceFirst(RegExp(r'^/+'), '')}';
}

String topicAssetPath(String topicName) {
  switch (topicName.toLowerCase().trim()) {
    case 'ekonomi':
      return 'assets/images/openData/ekonomi.svg';
    case 'infrastruktur':
      return 'assets/images/openData/infrastruktur.svg';
    case 'kemiskinan':
      return 'assets/images/openData/kemiskinan.svg';
    case 'kependudukan':
      return 'assets/images/openData/kependudukan.svg';
    case 'kesehatan':
      return 'assets/images/openData/kesehatan.svg';
    case 'lingkungan hidup':
      return 'assets/images/openData/lingkungan.svg';
    case 'pemerintah & desa':
      return 'assets/images/openData/pemerintah.svg';
    case 'pendidikan':
      return 'assets/images/openData/pendidikan.svg';
    case 'sosial':
      return 'assets/images/openData/sosial.svg';
    case 'tata ruang':
      return 'assets/images/openData/tataruang.svg';
    default:
      return 'assets/images/openData/ekonomi.svg';
  }
}

String stripHtml(String value) {
  return value
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n\n')
      .replaceAll(RegExp(r'<[^>]*>'), ' ')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll(RegExp(r'[ \t]+'), ' ')
      .replaceAll(RegExp(r'\n\s+\n'), '\n\n')
      .trim();
}

String formatOpenDataNumber(num value) {
  final raw = value.round().toString();
  final buffer = StringBuffer();

  for (var i = 0; i < raw.length; i++) {
    final positionFromEnd = raw.length - i;
    buffer.write(raw[i]);
    if (positionFromEnd > 1 && positionFromEnd % 3 == 1) {
      buffer.write('.');
    }
  }

  return buffer.toString();
}

String formatOpenDataDate(String value) {
  if (value.trim().isEmpty) {
    return '-';
  }

  final parsed = DateTime.tryParse(value);
  if (parsed == null) {
    return value;
  }

  const months = [
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

  final local = parsed.toLocal();
  return '${local.day.toString().padLeft(2, '0')} '
      '${months[local.month - 1]} ${local.year}';
}

String buildOpenDataWhere({
  String topicName = '',
  String organizationName = '',
}) {
  final filter = <String, dynamic>{'is_active': true, 'is_deleted': false};
  if (topicName.trim().isNotEmpty) {
    filter['topik_name'] = topicName.trim();
  }
  if (organizationName.trim().isNotEmpty) {
    filter['organisasi_name'] = organizationName.trim();
  }
  return jsonEncode(filter);
}

String _dimensionFromMetadata(Map<String, dynamic> json) {
  final metadata = json['metadata'];
  if (metadata is! List) {
    return '-';
  }

  String start = '';
  String end = '';
  for (final item in metadata.whereType<Map<String, dynamic>>()) {
    final key = item['key']?.toString().toLowerCase() ?? '';
    if (key.contains('dimensi dataset awal')) {
      start = item['value']?.toString() ?? '';
    }
    if (key.contains('dimensi dataset akhir')) {
      end = item['value']?.toString() ?? '';
    }
  }

  if (start.isNotEmpty && end.isNotEmpty) {
    return '$start-$end';
  }
  if (start.isNotEmpty) {
    return start;
  }
  if (end.isNotEmpty) {
    return end;
  }
  return '-';
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
