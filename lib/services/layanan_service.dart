import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'auth_service.dart';

class LayananException implements Exception {
  LayananException(this.message);

  final String message;

  @override
  String toString() => message;
}

class LayananModel {
  LayananModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.categoryName,
    required this.nawaBhaktiSatya,
    required this.isInstalled,
    required this.isFavorite,
    required this.isFeatured,
    required this.installCount,
  });

  final int id;
  final String name;
  final String description;
  final String iconUrl;
  final String categoryName;
  final String nawaBhaktiSatya;
  final bool isInstalled;
  final bool isFavorite;
  final bool isFeatured;
  final int installCount;

  LayananModel copyWith({
    bool? isInstalled,
    bool? isFavorite,
    int? installCount,
  }) {
    return LayananModel(
      id: id,
      name: name,
      description: description,
      iconUrl: iconUrl,
      categoryName: categoryName,
      nawaBhaktiSatya: nawaBhaktiSatya,
      isInstalled: isInstalled ?? this.isInstalled,
      isFavorite: isFavorite ?? this.isFavorite,
      isFeatured: isFeatured,
      installCount: installCount ?? this.installCount,
    );
  }

  factory LayananModel.fromJson(Map<String, dynamic> json) {
    final category = json['category'];

    return LayananModel(
      id: _toInt(json['id']),
      name: json['nama']?.toString() ?? '',
      description: json['deskripsi']?.toString() ?? '',
      iconUrl: json['icon_url']?.toString() ?? '',
      categoryName: category is Map<String, dynamic>
          ? category['nama']?.toString() ?? ''
          : '',
      nawaBhaktiSatya: json['nawa_bhakti_satya']?.toString() ?? '',
      isInstalled: json['is_installed'] == true,
      isFavorite: json['is_favorite'] == true,
      isFeatured: json['is_featured'] == true,
      installCount: _toInt(json['install_count']),
    );
  }
}

extension LayananAvailability on LayananModel {
  bool get isAvailable => isInstallableLayananName(name);
}

class LayananCategoryModel {
  LayananCategoryModel({required this.id, required this.name});

  final int id;
  final String name;

  factory LayananCategoryModel.fromJson(Map<String, dynamic> json) {
    return LayananCategoryModel(
      id: _toInt(json['id']),
      name: json['nama']?.toString() ?? '',
    );
  }
}

class LayananService {
  LayananService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  void dispose() {
    _client.close();
  }

  Future<List<LayananModel>> getPublicLayanan({String search = ''}) async {
    final queryParameters = <String, String>{};
    if (search.trim().isNotEmpty) {
      queryParameters['search'] = search.trim();
    }

    final decoded = await _get(
      '/public/layanan',
      queryParameters: queryParameters,
      includeOptionalAuth: true,
    );
    return _listFromPayload(decoded);
  }

  Future<List<LayananCategoryModel>> getPublicCategories() async {
    final decoded = await _get('/public/layanan/categories');
    return _categoryListFromPayload(decoded);
  }

  Future<List<LayananModel>> getInstalledLayanan({String search = ''}) async {
    if (AuthService.currentSession == null) {
      return const [];
    }

    final queryParameters = <String, String>{};
    if (search.trim().isNotEmpty) {
      queryParameters['search'] = search.trim();
    }

    final decoded = await _get(
      '/layanan/installed',
      queryParameters: queryParameters,
      requireAuth: true,
    );
    return _listFromPayload(decoded);
  }

  Future<List<LayananModel>> getFavoriteLayanan({String search = ''}) async {
    if (AuthService.currentSession == null) {
      return const [];
    }

    final queryParameters = <String, String>{};
    if (search.trim().isNotEmpty) {
      queryParameters['search'] = search.trim();
    }

    final decoded = await _get(
      '/layanan/favorites',
      queryParameters: queryParameters,
      requireAuth: true,
    );
    return _listFromPayload(decoded);
  }

  Future<void> installLayanan(int layananId) async {
    await _post('/layanan', body: {'layanan_id': layananId}, requireAuth: true);
  }

  Future<void> uninstallLayanan(int layananId) async {
    await _delete('/layanan/$layananId');
  }

  Future<void> addFavoriteLayanan(int layananId) async {
    await _post(
      '/layanan/favorites',
      body: {'layanan_id': layananId},
      requireAuth: true,
    );
  }

  Future<void> removeFavoriteLayanan(int layananId) async {
    await _delete('/layanan/favorites/$layananId');
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, String> queryParameters = const {},
    bool requireAuth = false,
    bool includeOptionalAuth = false,
  }) async {
    http.Response response;

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$path').replace(
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      );
      response = await _client.get(
        uri,
        headers: _headers(
          requireAuth: requireAuth,
          includeOptionalAuth: includeOptionalAuth,
        ),
      );
    } catch (_) {
      throw LayananException('Tidak dapat terhubung ke server layanan.');
    }

    final decoded = _decode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw LayananException(
        decoded['error']?.toString() ??
            decoded['message']?.toString() ??
            'Gagal mengambil data layanan.',
      );
    }

    return decoded;
  }

  Future<Map<String, dynamic>> _post(
    String path, {
    required Map<String, dynamic> body,
    required bool requireAuth,
  }) async {
    http.Response response;

    try {
      response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: _headers(requireAuth: requireAuth, hasJsonBody: true),
        body: jsonEncode(body),
      );
    } catch (_) {
      throw LayananException('Tidak dapat terhubung ke server layanan.');
    }

    final decoded = _decode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw LayananException(
        decoded['error']?.toString() ??
            decoded['message']?.toString() ??
            'Gagal memproses layanan.',
      );
    }

    return decoded;
  }

  Future<Map<String, dynamic>> _delete(String path) async {
    http.Response response;

    try {
      response = await _client.delete(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: _headers(requireAuth: true),
      );
    } catch (_) {
      throw LayananException('Tidak dapat terhubung ke server layanan.');
    }

    final decoded = _decode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw LayananException(
        decoded['error']?.toString() ??
            decoded['message']?.toString() ??
            'Gagal memproses layanan.',
      );
    }

    return decoded;
  }

  Map<String, String> _headers({
    required bool requireAuth,
    bool includeOptionalAuth = false,
    bool hasJsonBody = false,
  }) {
    final headers = <String, String>{'Accept': 'application/json'};
    if (hasJsonBody) {
      headers['Content-Type'] = 'application/json';
    }

    final session = AuthService.currentSession;

    if ((requireAuth || includeOptionalAuth) && session != null) {
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

  List<LayananModel> _listFromPayload(Map<String, dynamic> decoded) {
    final rawData = decoded['data'];
    if (rawData is! List) {
      return const [];
    }

    return rawData
        .whereType<Map<String, dynamic>>()
        .map(LayananModel.fromJson)
        .where((item) => item.id > 0 && item.name.isNotEmpty)
        .toList();
  }

  List<LayananCategoryModel> _categoryListFromPayload(
    Map<String, dynamic> decoded,
  ) {
    final rawData = decoded['data'];
    if (rawData is! List) {
      return const [];
    }

    return rawData
        .whereType<Map<String, dynamic>>()
        .map(LayananCategoryModel.fromJson)
        .where((item) => item.id > 0 && item.name.isNotEmpty)
        .toList();
  }
}

bool isInstallableLayananName(String name) {
  final normalized = name.toLowerCase();

  return normalized.contains('open data') ||
      normalized.contains('klinik hoaks') ||
      normalized.contains('harga bahan pokok') ||
      normalized.contains('nomor darurat') ||
      normalized.contains('rsud haji') ||
      normalized.contains('saiful anwar') ||
      normalized.contains('transjatim') ||
      normalized.contains('point jatim') ||
      normalized.contains('islamic') ||
      normalized.contains('destinasi wisata');
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
