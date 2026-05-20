import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'auth_service.dart';

class RsudHajiException implements Exception {
  RsudHajiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class RsudHajiOccupancy {
  const RsudHajiOccupancy({
    required this.summary,
    required this.rooms,
  });

  final RsudHajiSummary summary;
  final List<RsudHajiRoom> rooms;

  factory RsudHajiOccupancy.fromJson(Map<String, dynamic> json) {
    final payload = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final rawRooms = payload['rooms'];

    return RsudHajiOccupancy(
      summary: RsudHajiSummary.fromJson(
        payload['summary'] is Map<String, dynamic>
            ? payload['summary'] as Map<String, dynamic>
            : <String, dynamic>{},
      ),
      rooms: rawRooms is List
          ? rawRooms
              .whereType<Map<String, dynamic>>()
              .map(RsudHajiRoom.fromJson)
              .toList()
          : const [],
    );
  }
}

class RsudHajiSummary {
  const RsudHajiSummary({
    required this.total,
    required this.occupied,
    required this.available,
    required this.lastUpdate,
  });

  final int total;
  final int occupied;
  final int available;
  final String lastUpdate;

  factory RsudHajiSummary.fromJson(Map<String, dynamic> json) {
    return RsudHajiSummary(
      total: _toInt(json['total']),
      occupied: _toInt(json['occupied']),
      available: _toInt(json['available']),
      lastUpdate: json['last_update']?.toString() ?? '',
    );
  }
}

class RsudHajiRoom {
  const RsudHajiRoom({
    required this.name,
    required this.total,
    required this.occupied,
    required this.available,
  });

  final String name;
  final int total;
  final int occupied;
  final int available;

  factory RsudHajiRoom.fromJson(Map<String, dynamic> json) {
    return RsudHajiRoom(
      name: json['name']?.toString() ?? '',
      total: _toInt(json['total']),
      occupied: _toInt(json['occupied']),
      available: _toInt(json['available']),
    );
  }
}

class RsudHajiService {
  RsudHajiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  void dispose() {
    _client.close();
  }

  Future<RsudHajiOccupancy> getRoomOccupancy() async {
    http.Response response;

    try {
      response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}/rsud-haji/room-occupancy'),
        headers: _headers(),
      );
    } catch (_) {
      throw RsudHajiException(
        'Tidak dapat terhubung ke server RSUD Haji.',
      );
    }

    final decoded = _decode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw RsudHajiException(
        decoded['error']?.toString() ??
            decoded['message']?.toString() ??
            'Gagal mengambil data okupansi kamar RSUD Haji.',
      );
    }

    return RsudHajiOccupancy.fromJson(decoded);
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
