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
    required this.isInstalled,
    required this.isFavorite,
    required this.isFeatured,
  });

  final int id;
  final String name;
  final String description;
  final String iconUrl;
  final String categoryName;
  final bool isInstalled;
  final bool isFavorite;
  final bool isFeatured;

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
      isInstalled: json['is_installed'] == true,
      isFavorite: json['is_favorite'] == true,
      isFeatured: json['is_featured'] == true,
    );
  }
}

class LayananService {
  LayananService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  void dispose() {
    _client.close();
  }

  Future<List<LayananModel>> getPublicLayanan() async {
    final decoded = await _get('/public/layanan', requireAuth: false);
    return _listFromPayload(decoded);
  }

  Future<List<LayananModel>> getInstalledLayanan() async {
    if (AuthService.currentSession == null) {
      return const [];
    }

    final decoded = await _get('/layanan/installed', requireAuth: true);
    return _listFromPayload(decoded);
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    required bool requireAuth,
  }) async {
    http.Response response;

    try {
      response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: _headers(requireAuth: requireAuth),
      );
    } catch (_) {
      throw LayananException(
        'Tidak dapat terhubung ke server layanan.',
      );
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

  Map<String, String> _headers({required bool requireAuth}) {
    final headers = <String, String>{'Accept': 'application/json'};
    final session = AuthService.currentSession;

    if (requireAuth && session != null) {
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
