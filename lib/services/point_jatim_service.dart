import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'auth_service.dart';

class PointJatimException implements Exception {
  PointJatimException(this.message);

  final String message;

  @override
  String toString() => message;
}

class PointJatimAssets {
  static const String fallbackImage = 'assets/images/point_jatim.png';
  static const String _storageBaseUrl =
      'https://point.jatimprov.go.id:8686/api/pirjatim/storage';

  static String imageUrl(String fileName) {
    final value = fileName.trim();
    if (value.isEmpty) {
      return '';
    }
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    return '$_storageBaseUrl/files_image_high/${Uri.encodeComponent(value)}';
  }
}

class PointJatimSector {
  const PointJatimSector({
    required this.id,
    required this.description,
    required this.descriptionEn,
    required this.statusActive,
  });

  final int id;
  final String description;
  final String descriptionEn;
  final bool statusActive;

  factory PointJatimSector.fromJson(Map<String, dynamic> json) {
    return PointJatimSector(
      id: PointJatimService.toInt(json['id']),
      description: json['description']?.toString().trim() ?? '',
      descriptionEn: json['descriptionEn']?.toString().trim() ?? '',
      statusActive: json['statusActive'] == true,
    );
  }
}

class PointJatimKomoditi {
  const PointJatimKomoditi({
    required this.id,
    required this.description,
    required this.sectorTypeId,
    required this.statusActive,
  });

  final int id;
  final String description;
  final int sectorTypeId;
  final bool statusActive;

  factory PointJatimKomoditi.fromJson(Map<String, dynamic> json) {
    return PointJatimKomoditi(
      id: PointJatimService.toInt(json['id']),
      description: json['description']?.toString().trim() ?? '',
      sectorTypeId: PointJatimService.toInt(json['fsectorTypeBean']),
      statusActive: json['statusActive'] == true,
    );
  }
}

class PointJatimRegion {
  const PointJatimRegion({
    required this.id,
    required this.description,
    required this.lat,
    required this.lon,
    required this.statusActive,
  });

  final int id;
  final String description;
  final double lat;
  final double lon;
  final bool statusActive;

  factory PointJatimRegion.fromJson(Map<String, dynamic> json) {
    return PointJatimRegion(
      id: PointJatimService.toInt(json['id']),
      description: json['description']?.toString().trim() ?? '',
      lat: PointJatimService.toDouble(json['lat']),
      lon: PointJatimService.toDouble(json['lon']),
      statusActive: json['statusActive'] == true,
    );
  }
}

class PointJatimPotensiResponse {
  const PointJatimPotensiResponse({
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.items,
  });

  final int totalItems;
  final int totalPages;
  final int currentPage;
  final List<PointJatimPotensiItem> items;

  factory PointJatimPotensiResponse.fromJson(Map<String, dynamic> json) {
    final wrapper = json['data'];
    final payload = wrapper is Map<String, dynamic> ? wrapper : json;
    final rawItems = payload['items'];

    return PointJatimPotensiResponse(
      totalItems: PointJatimService.toInt(payload['totalItems']),
      totalPages: PointJatimService.toInt(payload['totalPages']),
      currentPage: PointJatimService.toInt(payload['currentPage']),
      items: rawItems is List
          ? rawItems
              .whereType<Map<String, dynamic>>()
              .map(PointJatimPotensiItem.fromJson)
              .where((item) => item.statusActive && item.title.isNotEmpty)
              .toList()
          : const [],
    );
  }
}

class PointJatimPotensiItem {
  const PointJatimPotensiItem({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.image,
    required this.statusActive,
    required this.sectorTypeId,
    required this.komoditiTypeId,
    required this.address,
    required this.district,
    required this.city,
    required this.jenis,
    required this.lat,
    required this.lon,
    required this.year,
    required this.investmentValue,
    required this.paybackPeriod,
    required this.npv,
    required this.irr,
    required this.businessField,
  });

  final int id;
  final String code;
  final String title;
  final String description;
  final String image;
  final bool statusActive;
  final int sectorTypeId;
  final int komoditiTypeId;
  final String address;
  final String district;
  final String city;
  final String jenis;
  final double lat;
  final double lon;
  final int year;
  final double investmentValue;
  final double paybackPeriod;
  final double npv;
  final double irr;
  final String businessField;

  String get imageUrl => PointJatimAssets.imageUrl(image);

  factory PointJatimPotensiItem.fromJson(Map<String, dynamic> json) {
    return PointJatimPotensiItem(
      id: PointJatimService.toInt(json['id']),
      code: json['kode1']?.toString().trim() ?? '',
      title: (json['kode2']?.toString().trim().isNotEmpty ?? false)
          ? json['kode2'].toString().trim()
          : json['kode1']?.toString().trim() ?? '',
      description: json['description']?.toString().trim() ?? '',
      image: json['avatarImage']?.toString().trim() ?? '',
      statusActive: json['statusActive'] == true,
      sectorTypeId: PointJatimService.toInt(json['fsectorTypeBean']),
      komoditiTypeId: PointJatimService.toInt(json['fkomoditiTypeBean']),
      address: json['address']?.toString().trim() ?? '',
      district: json['district']?.toString().trim() ?? '',
      city: json['city']?.toString().trim() ?? '',
      jenis: json['jenis']?.toString().trim() ?? '',
      lat: PointJatimService.toDouble(json['lat']),
      lon: PointJatimService.toDouble(json['lon']),
      year: PointJatimService.toInt(json['tahun']),
      investmentValue: PointJatimService.toDouble(json['nilaiInvestasi']),
      paybackPeriod: PointJatimService.toDouble(json['payBackPeriode']),
      npv: PointJatimService.toDouble(json['npv']),
      irr: PointJatimService.toDouble(json['irr']),
      businessField: json['bidangUsaha']?.toString().trim() ?? '',
    );
  }
}

class PointJatimService {
  PointJatimService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  void dispose() {
    _client.close();
  }

  Future<List<PointJatimSector>> getSectors() async {
    final decoded = await _get('/point-jatim/sector');
    return _listPayload(decoded)
        .whereType<Map<String, dynamic>>()
        .map(PointJatimSector.fromJson)
        .where((item) => item.id != 0 && item.description.isNotEmpty)
        .toList();
  }

  Future<List<PointJatimKomoditi>> getKomoditi() async {
    final decoded = await _get('/point-jatim/komoditi');
    return _listPayload(decoded)
        .whereType<Map<String, dynamic>>()
        .map(PointJatimKomoditi.fromJson)
        .where((item) => item.id != 0 && item.description.isNotEmpty)
        .toList();
  }

  Future<List<PointJatimRegion>> getRegions() async {
    final decoded = await _get('/point-jatim/region');
    return _listPayload(decoded)
        .whereType<Map<String, dynamic>>()
        .map(PointJatimRegion.fromJson)
        .where((item) => item.id != 0 && item.description.isNotEmpty)
        .toList();
  }

  Future<PointJatimPotensiResponse> getPotensi({
    int pageNo = 1,
    int pageSize = 100,
    String sortBy = 'id',
    String order = 'DESC',
    String jenis = 'IPRO',
    String search = '',
    List<int> areaIds = const [],
    List<int> komoditiTypeIds = const [],
    List<int> sectorTypeIds = const [],
  }) async {
    final decoded = await _post('/point-jatim/potensi', {
      'id': 0,
      'pageNo': pageNo,
      'pageSize': pageSize,
      'sortBy': sortBy,
      'order': order,
      'jenis': jenis,
      'search': search,
      'fareaIds': areaIds,
      'fkomoditiTypeIds': komoditiTypeIds,
      'fsectorTypeIds': sectorTypeIds,
    });

    return PointJatimPotensiResponse.fromJson(decoded);
  }

  Future<Map<String, dynamic>> _get(String path) async {
    http.Response response;

    try {
      response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: _headers(),
      );
    } catch (_) {
      throw PointJatimException(
        'Tidak dapat terhubung ke server Point Jatim.',
      );
    }

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    http.Response response;

    try {
      response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: _headers(contentTypeJson: true),
        body: jsonEncode(body),
      );
    } catch (_) {
      throw PointJatimException(
        'Tidak dapat terhubung ke server Point Jatim.',
      );
    }

    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final decoded = _decode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw PointJatimException(
        decoded['error']?.toString() ??
            decoded['message']?.toString() ??
            'Gagal mengambil data Point Jatim.',
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

  List<dynamic> _listPayload(Map<String, dynamic> decoded) {
    final data = decoded['data'];
    return data is List ? data : const [];
  }

  Map<String, String> _headers({bool contentTypeJson = false}) {
    final headers = <String, String>{'Accept': 'application/json'};
    if (contentTypeJson) {
      headers['Content-Type'] = 'application/json';
    }

    final session = AuthService.currentSession;
    if (session != null) {
      headers['Authorization'] = session.authorizationHeader;
    }
    return headers;
  }

  static int toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double toDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
