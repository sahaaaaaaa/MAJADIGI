import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'auth_service.dart';

class DestinasiWisataException implements Exception {
  DestinasiWisataException(this.message);

  final String message;

  @override
  String toString() => message;
}

class WisataDestination {
  const WisataDestination({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.shortDescription,
    required this.rating,
    required this.totalReviews,
    required this.city,
    required this.category,
    required this.isFavorite,
  });

  final int id;
  final String name;
  final String thumbnail;
  final String shortDescription;
  final double rating;
  final int totalReviews;
  final String city;
  final String category;
  final bool isFavorite;

  factory WisataDestination.fromJson(Map<String, dynamic> json) {
    return WisataDestination(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      shortDescription: json['short_description']?.toString() ?? '',
      rating: _toDouble(json['rating']),
      totalReviews: _toInt(json['total_reviews']),
      city: json['city']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      isFavorite: json['is_favorite'] == true,
    );
  }

  WisataDestination copyWith({bool? isFavorite}) {
    return WisataDestination(
      id: id,
      name: name,
      thumbnail: thumbnail,
      shortDescription: shortDescription,
      rating: rating,
      totalReviews: totalReviews,
      city: city,
      category: category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class WisataDestinationDetail {
  const WisataDestinationDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.rating,
    required this.totalReviews,
    required this.city,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.isFavorite,
    required this.images,
    required this.category,
  });

  final int id;
  final String name;
  final String description;
  final double rating;
  final int totalReviews;
  final String city;
  final String address;
  final double latitude;
  final double longitude;
  final String status;
  final bool isFavorite;
  final List<String> images;
  final WisataCategory category;

  String get primaryImage => images.isNotEmpty ? images.first : '';

  bool get hasCoordinate => latitude != 0 || longitude != 0;

  factory WisataDestinationDetail.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'];
    final rawCategory = json['category'];

    return WisataDestinationDetail(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      rating: _toDouble(json['rating']),
      totalReviews: _toInt(json['total_reviews']),
      city: json['city']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      status: json['status']?.toString() ?? '',
      isFavorite: json['is_favorite'] == true,
      images: rawImages is List
          ? rawImages
                .map((item) => item?.toString() ?? '')
                .where((item) => item.isNotEmpty)
                .toList()
          : const [],
      category: rawCategory is Map<String, dynamic>
          ? WisataCategory.fromJson(rawCategory)
          : const WisataCategory(id: 0, name: ''),
    );
  }
}

class WisataCategory {
  const WisataCategory({required this.id, required this.name});

  final int id;
  final String name;

  factory WisataCategory.fromJson(Map<String, dynamic> json) {
    return WisataCategory(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? '',
    );
  }
}

class WisataFavorite {
  const WisataFavorite({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.city,
  });

  final int id;
  final String name;
  final String thumbnail;
  final String city;

  factory WisataFavorite.fromJson(Map<String, dynamic> json) {
    return WisataFavorite(
      id: _toInt(json['id']),
      name: json['name']?.toString() ?? '',
      thumbnail: json['thumbnail']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
    );
  }
}

class DestinasiWisataService {
  DestinasiWisataService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  void dispose() {
    _client.close();
  }

  Future<List<WisataDestination>> getDestinations() async {
    final decoded = await _get('/destinasi-wisata/destinations');
    final data = decoded['data'];
    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(WisataDestination.fromJson)
        .where((item) => item.id > 0 && item.name.isNotEmpty)
        .toList();
  }

  Future<WisataDestinationDetail> getDestinationDetail(int id) async {
    final decoded = await _get('/destinasi-wisata/destinations/$id');
    final data = decoded['data'];
    if (data is Map<String, dynamic>) {
      return WisataDestinationDetail.fromJson(data);
    }
    throw DestinasiWisataException('Detail destinasi wisata tidak ditemukan.');
  }

  Future<List<WisataCategory>> getCategories() async {
    final decoded = await _get('/destinasi-wisata/categories');
    final data = decoded['data'];
    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(WisataCategory.fromJson)
        .where((item) => item.id > 0 && item.name.isNotEmpty)
        .toList();
  }

  Future<void> addFavorite(int destinationId) async {
    try {
      await _post(
        '/destinasi-wisata/favorites',
        body: {'destination_id': destinationId},
      );
    } on DestinasiWisataException catch (error) {
      if (_isDuplicateFavoriteError(error.message)) {
        return;
      }
      rethrow;
    }
  }

  Future<List<WisataFavorite>> getFavorites() async {
    final decoded = await _get('/destinasi-wisata/favorites');
    final data = decoded['data'];
    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(WisataFavorite.fromJson)
        .where((item) => item.id > 0 && item.name.isNotEmpty)
        .toList();
  }

  Future<void> removeFavorite(int destinationId) async {
    await _delete('/destinasi-wisata/favorites/$destinationId');
  }

  Future<Map<String, dynamic>> _get(String path) async {
    http.Response response;

    try {
      response = await _client.get(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: _headers(),
      );
    } catch (_) {
      throw DestinasiWisataException(
        'Tidak dapat terhubung ke server destinasi wisata.',
      );
    }

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> _post(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    http.Response response;

    try {
      response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: _headers(includeContentType: true),
        body: jsonEncode(body),
      );
    } catch (_) {
      throw DestinasiWisataException(
        'Tidak dapat terhubung ke server destinasi wisata.',
      );
    }

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> _delete(String path) async {
    http.Response response;

    try {
      response = await _client.delete(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: _headers(),
      );
    } catch (_) {
      throw DestinasiWisataException(
        'Tidak dapat terhubung ke server destinasi wisata.',
      );
    }

    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final decoded = _decode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw DestinasiWisataException(
        decoded['error']?.toString() ??
            decoded['message']?.toString() ??
            'Gagal mengambil data destinasi wisata.',
      );
    }

    return decoded;
  }

  Map<String, String> _headers({bool includeContentType = false}) {
    final headers = <String, String>{'Accept': 'application/json'};
    if (includeContentType) {
      headers['Content-Type'] = 'application/json';
    }

    final session = AuthService.currentSession;
    if (session != null) {
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

  bool _isDuplicateFavoriteError(String message) {
    final normalized = message.toLowerCase();
    return normalized.contains('idx_user_destination') ||
        normalized.contains('duplicate key') ||
        normalized.contains('unique constraint');
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

double _toDouble(dynamic value) {
  if (value is double) {
    return value;
  }
  if (value is num) {
    return value.toDouble();
  }
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
