import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';

class RegisterRequest {
  RegisterRequest({
    required this.namaDepan,
    required this.namaBelakang,
    required this.noHandphone,
    required this.email,
    required this.alamat,
    required this.kabupatenKota,
    required this.kecamatan,
    required this.nik,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.password,
    required this.ulangiPassword,
  });

  final String namaDepan;
  final String namaBelakang;
  final String noHandphone;
  final String email;
  final String alamat;
  final String kabupatenKota;
  final String kecamatan;
  final String nik;
  final String tanggalLahir;
  final String jenisKelamin;
  final String password;
  final String ulangiPassword;

  Map<String, dynamic> toJson({List<int> layananIds = const []}) {
    return {
      'nama_depan': namaDepan,
      'nama_belakang': namaBelakang,
      'no_handphone': noHandphone,
      'email': email,
      'alamat': alamat,
      'kabupaten_kota': kabupatenKota,
      'kecamatan': kecamatan,
      'nik': nik,
      'tanggal_lahir': tanggalLahir,
      'jenis_kelamin': jenisKelamin,
      'password': password,
      'ulangi_password': ulangiPassword,
      'layanan_ids': layananIds,
    };
  }
}

class AuthUser {
  AuthUser({
    required this.id,
    required this.email,
    required this.role,
  });

  final String id;
  final String email;
  final String role;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }
}

class AuthSession {
  AuthSession({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final AuthUser user;

  String get authorizationHeader => '$tokenType $accessToken';

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];

    return AuthSession(
      accessToken: json['access_token']?.toString() ?? '',
      tokenType: json['token_type']?.toString() ?? 'Bearer',
      expiresIn: _toInt(json['expires_in']),
      user: userJson is Map<String, dynamic>
          ? AuthUser.fromJson(userJson)
          : AuthUser(id: '', email: '', role: ''),
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

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.fieldErrors});

  final String message;
  final int? statusCode;
  final Map<String, String>? fieldErrors;

  @override
  String toString() => message;
}

class AuthService {
  static AuthSession? currentSession;

  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  void dispose() {
    _client.close();
  }

  Future<AuthSession> login({
    required String email,
    required String password,
  }) {
    return _postAuth(
      '/auth/login',
      body: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<AuthSession> register({
    required RegisterRequest request,
    List<int> layananIds = const [],
  }) {
    return _postAuth(
      '/auth/register',
      body: request.toJson(layananIds: layananIds),
    );
  }

  void logout() {
    clearSession();
  }

  static void clearSession() {
    currentSession = null;
  }

  Future<AuthSession> _postAuth(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    http.Response response;

    try {
      response = await _client.post(
        Uri.parse('${ApiConfig.baseUrl}$path'),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );
    } catch (_) {
      throw ApiException(
        'Tidak dapat terhubung ke server. Pastikan backend berjalan.',
      );
    }

    final decoded = _decodeResponse(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        _errorMessage(decoded),
        statusCode: response.statusCode,
        fieldErrors: _fieldErrors(decoded),
      );
    }

    final data = decoded['data'];
    if (data is! Map<String, dynamic>) {
      throw ApiException('Format response server tidak valid.');
    }

    final session = AuthSession.fromJson(data);
    if (session.accessToken.isEmpty) {
      throw ApiException('Token login tidak ditemukan dari server.');
    }

    currentSession = session;
    return session;
  }

  Map<String, dynamic> _decodeResponse(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {}

    return {};
  }

  String _errorMessage(Map<String, dynamic> decoded) {
    final fieldErrors = _fieldErrors(decoded);
    if (fieldErrors != null && fieldErrors.isNotEmpty) {
      return fieldErrors.values.first;
    }

    return decoded['error']?.toString() ??
        decoded['message']?.toString() ??
        'Request gagal diproses.';
  }

  Map<String, String>? _fieldErrors(Map<String, dynamic> decoded) {
    final errors = decoded['errors'];
    if (errors is! Map) {
      return null;
    }

    return errors.map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
  }
}
