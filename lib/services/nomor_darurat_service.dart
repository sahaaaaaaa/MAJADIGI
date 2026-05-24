import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'auth_service.dart';

class NomorDaruratException implements Exception {
  NomorDaruratException(this.message);

  final String message;

  @override
  String toString() => message;
}

class KabKotaDarurat {
  KabKotaDarurat({
    required this.id,
    required this.name,
    required this.slug,
    required this.logo,
    required this.address,
    required this.hasService,
    required this.isIntegrated,
  });

  final String id;
  final String name;
  final String slug;
  final String logo;
  final String address;
  final bool hasService;
  final bool isIntegrated;

  factory KabKotaDarurat.fromJson(Map<String, dynamic> json) {
    return KabKotaDarurat(
      id: json['id']?.toString() ?? '',
      name: json['nama_daerah']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      logo: json['logo']?.toString() ?? '',
      address: json['alamat']?.toString() ?? '',
      hasService: json['has_service'] == true,
      isIntegrated: json['is_integrated'] == true,
    );
  }
}

class NomorDaruratItem {
  NomorDaruratItem({
    required this.id,
    required this.name,
    required this.number,
    required this.description,
    required this.isNational,
    required this.isProvince,
    required this.kabKotaId,
  });

  final String id;
  final String name;
  final String number;
  final String description;
  final bool isNational;
  final bool isProvince;
  final String kabKotaId;

  factory NomorDaruratItem.fromJson(Map<String, dynamic> json) {
    return NomorDaruratItem(
      id: json['id']?.toString() ?? '',
      name: json['nama']?.toString() ?? '',
      number: json['nomor']?.toString() ?? '',
      description: json['deskripsi']?.toString() ?? '',
      isNational: json['is_nasional'] == true,
      isProvince: json['is_provinsi'] == true,
      kabKotaId: json['kab_kota_id']?.toString() ?? '',
    );
  }
}

class NomorDaruratService {
  NomorDaruratService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  void dispose() {
    _client.close();
  }

  Future<List<KabKotaDarurat>> getKabKota() async {
    final decoded = await _get('/nomor-darurat/kab-kota');
    return _listFromPayload(decoded)
        .whereType<Map<String, dynamic>>()
        .map(KabKotaDarurat.fromJson)
        .where((item) => item.id.isNotEmpty && item.name.isNotEmpty)
        .toList();
  }

  Future<List<NomorDaruratItem>> getNomorDarurat({String? kabKotaId}) async {
    final params = <String, String>{
      if (kabKotaId != null && kabKotaId.trim().isNotEmpty)
        'kab_kota_id': kabKotaId.trim(),
    };

    final decoded = await _get('/nomor-darurat', queryParameters: params);
    return _listFromPayload(decoded)
        .whereType<Map<String, dynamic>>()
        .map(NomorDaruratItem.fromJson)
        .where((item) => item.name.isNotEmpty && item.number.isNotEmpty)
        .toList();
  }

  Future<Map<String, dynamic>> _get(
    String path, {
    Map<String, String> queryParameters = const {},
  }) async {
    http.Response response;

    try {
      response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}$path').replace(
          queryParameters:
              queryParameters.isEmpty ? null : queryParameters,
        ),
        headers: _headers(),
      );
    } catch (_) {
      throw NomorDaruratException(
        'Tidak dapat terhubung ke server nomor darurat.',
      );
    }

    final decoded = _decode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw NomorDaruratException(
        decoded['error']?.toString() ??
            decoded['message']?.toString() ??
            'Gagal mengambil data nomor darurat.',
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

  List<dynamic> _listFromPayload(Map<String, dynamic> decoded) {
    final wrapperData = decoded['data'];
    if (wrapperData is! Map<String, dynamic>) {
      return const [];
    }

    final data = wrapperData['data'];
    if (data is List) {
      return data;
    }

    return const [];
  }

  Map<String, String> _headers() {
    final headers = <String, String>{'Accept': 'application/json'};
    final session = AuthService.currentSession;
    if (session != null) {
      headers['Authorization'] = session.authorizationHeader;
    }
    return headers;
  }
}
