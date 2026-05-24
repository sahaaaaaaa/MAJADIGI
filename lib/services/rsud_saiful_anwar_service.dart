import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'auth_service.dart';

class RsudSaifulAnwarException implements Exception {
  RsudSaifulAnwarException(this.message);

  final String message;

  @override
  String toString() => message;
}

class RsudSaifulAnwarOccupancy {
  const RsudSaifulAnwarOccupancy({
    required this.summary,
    required this.rooms,
  });

  final RsudSaifulAnwarSummary summary;
  final List<RsudSaifulAnwarRoom> rooms;

  factory RsudSaifulAnwarOccupancy.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final rawRooms = payload['rooms'];

    return RsudSaifulAnwarOccupancy(
      summary: RsudSaifulAnwarSummary.fromJson(
        payload['summary'] is Map<String, dynamic>
            ? payload['summary'] as Map<String, dynamic>
            : <String, dynamic>{},
      ),
      rooms: rawRooms is List
          ? rawRooms
              .whereType<Map<String, dynamic>>()
              .map(RsudSaifulAnwarRoom.fromJson)
              .toList()
          : const [],
    );
  }
}

class RsudSaifulAnwarSummary {
  const RsudSaifulAnwarSummary({
    required this.total,
    required this.occupied,
    required this.available,
    required this.lastUpdate,
  });

  final int total;
  final int occupied;
  final int available;
  final String lastUpdate;

  factory RsudSaifulAnwarSummary.fromJson(Map<String, dynamic> json) {
    return RsudSaifulAnwarSummary(
      total: _toInt(json['total']),
      occupied: _toInt(json['occupied']),
      available: _toInt(json['available']),
      lastUpdate: json['last_update']?.toString() ?? '',
    );
  }
}

class RsudSaifulAnwarRoom {
  const RsudSaifulAnwarRoom({
    required this.name,
    required this.type,
    required this.total,
    required this.occupied,
    required this.available,
  });

  final String name;
  final String type;
  final int total;
  final int occupied;
  final int available;

  factory RsudSaifulAnwarRoom.fromJson(Map<String, dynamic> json) {
    return RsudSaifulAnwarRoom(
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      total: _toInt(json['total']),
      occupied: _toInt(json['occupied']),
      available: _toInt(json['available']),
    );
  }
}

class RsudSaifulAnwarService {
  RsudSaifulAnwarService({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  void dispose() {
    _client.close();
  }

  Future<RsudSaifulAnwarOccupancy> getRoomOccupancy() async {
    http.Response response;

    try {
      response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/rsud-saiful-anwar/room-occupancy'),
        headers: _headers(),
      );
    } catch (_) {
      throw RsudSaifulAnwarException(
        'Tidak dapat terhubung ke server RSUD Saiful Anwar.',
      );
    }

    final decoded = _decode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw RsudSaifulAnwarException(
        decoded['error']?.toString() ??
            decoded['message']?.toString() ??
            'Gagal mengambil data okupansi kamar RSUD Saiful Anwar.',
      );
    }

    return RsudSaifulAnwarOccupancy.fromJson(decoded);
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

int _toInt(dynamic value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse(value?.toString() ?? '') ?? 0;
}
