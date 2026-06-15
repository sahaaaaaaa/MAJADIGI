import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:majadigi/core/services/api_config.dart';
import 'package:majadigi/features/auth/data/auth_service.dart';

class HargaPokokException implements Exception {
  HargaPokokException(this.message);

  final String message;

  @override
  String toString() => message;
}

class HargaPokokResponse {
  HargaPokokResponse({
    required this.date,
    required this.priceList,
    required this.page,
    required this.perPage,
    required this.total,
    required this.nextPage,
  });

  final String date;
  final List<HargaPokokItem> priceList;
  final int page;
  final int perPage;
  final int total;
  final String nextPage;

  bool get hasNextPage => nextPage.isNotEmpty;

  factory HargaPokokResponse.fromJson(Map<String, dynamic> json) {
    final wrapperData = json['data'];
    final payload = wrapperData is Map<String, dynamic>
        ? wrapperData
        : <String, dynamic>{};
    final nestedData = payload['data'];
    final priceData = nestedData is Map<String, dynamic>
        ? nestedData
        : <String, dynamic>{};
    final rawPriceList = priceData['priceList'];

    return HargaPokokResponse(
      date: priceData['date']?.toString() ?? '',
      priceList: rawPriceList is List
          ? rawPriceList
              .whereType<Map<String, dynamic>>()
              .map(HargaPokokItem.fromJson)
              .toList()
          : const [],
      page: _toInt(payload['page']),
      perPage: _toInt(payload['perPage']),
      total: _toInt(payload['total']),
      nextPage: payload['nextPage']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class HargaPokokItem {
  HargaPokokItem({
    required this.id,
    required this.name,
    required this.unit,
    required this.diff,
    required this.diffPercent,
    required this.icon,
    required this.imageUrl,
    required this.price,
    required this.yesterdayPrice,
  });

  final int id;
  final String name;
  final String unit;
  final int diff;
  final String diffPercent;
  final String icon;
  final String imageUrl;
  final int price;
  final int yesterdayPrice;

  bool get isDown {
    final normalizedIcon = icon.toLowerCase();
    return normalizedIcon == 'down' ||
        (normalizedIcon != 'up' && normalizedIcon != 'minus' && diff < 0);
  }

  bool get isUp {
    final normalizedIcon = icon.toLowerCase();
    return normalizedIcon == 'up' ||
        (normalizedIcon != 'down' && normalizedIcon != 'minus' && diff > 0);
  }

  bool get isFlat => !isDown && !isUp;

  double get diffPercentValue {
    final normalized = diffPercent.replaceAll('%', '').trim();
    return double.tryParse(normalized) ?? 0;
  }

  factory HargaPokokItem.fromJson(Map<String, dynamic> json) {
    return HargaPokokItem(
      id: HargaPokokResponse._toInt(json['bp_id']),
      name: json['commodity_name']?.toString() ?? '',
      unit: json['commodity_unit']?.toString() ?? '',
      diff: HargaPokokResponse._toInt(json['diff']),
      diffPercent: json['diff_percent']?.toString() ?? '0 %',
      icon: json['icon']?.toString() ?? 'minus',
      imageUrl: json['image']?.toString() ?? '',
      price: HargaPokokResponse._toInt(json['price']),
      yesterdayPrice: HargaPokokResponse._toInt(json['y_price']),
    );
  }
}

class HargaPokokService {
  HargaPokokService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  void dispose() {
    _client.close();
  }

  Future<HargaPokokResponse> getPrices({
    int page = 1,
    int limit = 12,
    String sort = 'name',
    String? date,
    String? name,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      'sort': sort,
      if (date != null && date.trim().isNotEmpty) 'date': date.trim(),
      if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
    };

    http.Response response;
    try {
      response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/harga-pokok').replace(
          queryParameters: params,
        ),
        headers: _headers(),
      );
    } catch (_) {
      throw HargaPokokException(
        'Tidak dapat terhubung ke server harga pokok.',
      );
    }

    final decoded = _decode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HargaPokokException(
        decoded['error']?.toString() ??
            decoded['message']?.toString() ??
            'Gagal mengambil data harga pokok.',
      );
    }

    return HargaPokokResponse.fromJson(decoded);
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
}
