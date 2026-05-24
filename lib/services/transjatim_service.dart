import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'auth_service.dart';

class TransjatimException implements Exception {
  TransjatimException(this.message);

  final String message;

  @override
  String toString() => message;
}

class TransjatimRouteInfo {
  const TransjatimRouteInfo({
    required this.corridor,
    required this.corridorCode,
    required this.operationHours,
    required this.colorHex,
    required this.serviceName,
    required this.routes,
  });

  final String corridor;
  final String corridorCode;
  final String operationHours;
  final String colorHex;
  final String serviceName;
  final List<String> routes;

  String get origin => routes.isNotEmpty ? routes.first : '-';
  String get destination => routes.length > 1 ? routes[1] : '-';

  factory TransjatimRouteInfo.fromJson(Map<String, dynamic> json) {
    final rawRoutes = json['routes'];

    return TransjatimRouteInfo(
      corridor: json['koridor']?.toString() ?? '',
      corridorCode: json['kode_koridor']?.toString() ?? '',
      operationHours: json['jam_ops']?.toString() ?? '',
      colorHex: json['color']?.toString() ?? '',
      serviceName: json['nama_layanan']?.toString() ?? 'Trans Jatim',
      routes: rawRoutes is List
          ? rawRoutes.map((item) => item.toString()).toList()
          : const [],
    );
  }
}

class TransjatimTariffResponse {
  const TransjatimTariffResponse({
    required this.regular,
    required this.luxury,
  });

  final List<TransjatimTariff> regular;
  final List<TransjatimTariff> luxury;

  factory TransjatimTariffResponse.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return TransjatimTariffResponse(
      regular: _tariffList(payload['regular']),
      luxury: _tariffList(payload['luxury']),
    );
  }

  static List<TransjatimTariff> _tariffList(dynamic value) {
    if (value is! List) {
      return const [];
    }

    final seen = <String>{};
    final tariffs = <TransjatimTariff>[];

    for (final item in value.whereType<Map<String, dynamic>>()) {
      final tariff = TransjatimTariff.fromJson(item);
      final key = '${tariff.type}|${tariff.nominal}';
      if (tariff.nominal.isNotEmpty && seen.add(key)) {
        tariffs.add(tariff);
      }
    }

    return tariffs;
  }
}

class TransjatimTariff {
  const TransjatimTariff({
    required this.type,
    required this.nominal,
  });

  final String type;
  final String nominal;

  factory TransjatimTariff.fromJson(Map<String, dynamic> json) {
    return TransjatimTariff(
      type: json['jenis_tarif']?.toString() ?? 'Umum',
      nominal: json['nominal_tarif']?.toString() ?? '',
    );
  }
}

class TransjatimBusStopResponse {
  const TransjatimBusStopResponse({
    required this.polyline,
    required this.stops,
    required this.routes,
  });

  final String polyline;
  final List<TransjatimBusStop> stops;
  final List<String> routes;

  factory TransjatimBusStopResponse.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final rawStops = payload['route'];
    final rawRoutes = payload['routes'];

    return TransjatimBusStopResponse(
      polyline: payload['polyline']?.toString() ?? '',
      stops: rawStops is List
          ? rawStops
              .whereType<Map<String, dynamic>>()
              .map(TransjatimBusStop.fromJson)
              .where((item) => item.name.isNotEmpty)
              .toList()
          : const [],
      routes: rawRoutes is List
          ? rawRoutes.map((item) => item.toString()).toList()
          : const [],
    );
  }
}

class TransjatimBusStop {
  const TransjatimBusStop({
    required this.id,
    required this.name,
    required this.corridor,
    required this.origin,
    required this.toward,
    required this.colorHex,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String name;
  final String corridor;
  final String origin;
  final String toward;
  final String colorHex;
  final String latitude;
  final String longitude;

  factory TransjatimBusStop.fromJson(Map<String, dynamic> json) {
    return TransjatimBusStop(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      corridor: json['kor']?.toString() ?? '',
      origin: json['origin']?.toString() ?? '',
      toward: json['toward']?.toString() ?? '',
      colorHex: json['color']?.toString() ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
    );
  }
}

class TransjatimService {
  TransjatimService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  void dispose() {
    _client.close();
  }

  Future<List<TransjatimRouteInfo>> getRoutes() async {
    final decoded = await _get('/transjatim/rute');
    final rawData = decoded['data'];

    if (rawData is! List) {
      return const [];
    }

    return rawData
        .whereType<Map<String, dynamic>>()
        .map(TransjatimRouteInfo.fromJson)
        .where((item) => item.corridor.isNotEmpty)
        .toList();
  }

  Future<TransjatimTariffResponse> getTariffs() async {
    final decoded = await _get('/transjatim/tarif');
    return TransjatimTariffResponse.fromJson(decoded);
  }

  Future<TransjatimBusStopResponse> getBusStops(String corridor) async {
    final decoded = await _get(
      '/transjatim/bus-stop',
      queryParameters: {'koridor': corridor},
    );
    return TransjatimBusStopResponse.fromJson(decoded);
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
      throw TransjatimException(
        'Tidak dapat terhubung ke server Transjatim.',
      );
    }

    final decoded = _decode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw TransjatimException(
        decoded['error']?.toString() ??
            decoded['message']?.toString() ??
            'Gagal mengambil data Transjatim.',
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
}
