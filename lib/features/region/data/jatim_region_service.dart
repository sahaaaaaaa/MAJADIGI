import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:majadigi/features/region/data/model/region_item.dart';

class JatimRegionService {
  JatimRegionService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl =
      'https://www.emsifa.com/api-wilayah-indonesia/api';

  Future<List<RegionItem>> getRegencies() async {
    return _fetchList('$_baseUrl/regencies/35.json');
  }

  Future<List<RegionItem>> getDistricts(String regencyId) async {
    return _fetchList('$_baseUrl/districts/$regencyId.json');
  }

  Future<List<RegionItem>> _fetchList(String url) async {
    http.Response response;

    try {
      response = await _client.get(
        Uri.parse(url),
        headers: const {'Accept': 'application/json'},
      );
    } catch (_) {
      throw Exception('Tidak dapat terhubung ke server wilayah.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal memuat data wilayah.');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      return const [];
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(RegionItem.fromJson)
        .where((item) => item.id.isNotEmpty && item.name.isNotEmpty)
        .toList();
  }

  void dispose() {
    _client.close;
  }
}
