import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:majadigi/core/services/api_config.dart';

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
  AuthUser({required this.id, required this.email, required this.role});

  final String id;
  final String email;
  final String role;

  AuthUser copyWith({String? id, String? email, String? role}) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'role': role};
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
    );
  }
}

class AuthProfile {
  AuthProfile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.kabupatenKota,
    required this.kecamatan,
    required this.nik,
    required this.birthDate,
    required this.gender,
    required this.photoUrl,
  });

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String kabupatenKota;
  final String kecamatan;
  final String nik;
  final String birthDate;
  final String gender;
  final String photoUrl;

  String get fullName => [
    firstName,
    lastName,
  ].where((item) => item.trim().isNotEmpty).join(' ').trim();

  AuthProfile copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
    String? kabupatenKota,
    String? kecamatan,
    String? nik,
    String? birthDate,
    String? gender,
    String? photoUrl,
  }) {
    return AuthProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      kabupatenKota: kabupatenKota ?? this.kabupatenKota,
      kecamatan: kecamatan ?? this.kecamatan,
      nik: nik ?? this.nik,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'address': address,
      'kabupaten_kota': kabupatenKota,
      'kecamatan': kecamatan,
      'nik': nik,
      'birth_date': birthDate,
      'gender': gender,
      'photo_url': photoUrl,
    };
  }

  factory AuthProfile.fromJson(Map<String, dynamic> json) {
    return AuthProfile(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      kabupatenKota: json['kabupaten_kota']?.toString() ?? '',
      kecamatan: json['kecamatan']?.toString() ?? '',
      nik: json['nik']?.toString() ?? '',
      birthDate: json['birth_date']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      photoUrl: json['photo_url']?.toString() ?? '',
    );
  }
}

class AuthSession {
  AuthSession({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
    this.profile,
  });

  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final AuthUser user;
  final AuthProfile? profile;

  String get authorizationHeader => '$tokenType $accessToken';
  String get firstName {
    final profileFirstName = profile?.firstName.trim() ?? '';
    if (profileFirstName.isNotEmpty) {
      return profileFirstName;
    }

    final emailName = user.email.split('@').first.trim();
    return emailName.isEmpty ? 'Pengguna' : emailName;
  }

  AuthSession copyWith({
    String? accessToken,
    String? tokenType,
    int? expiresIn,
    AuthUser? user,
    AuthProfile? profile,
  }) {
    return AuthSession(
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      user: user ?? this.user,
      profile: profile ?? this.profile,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'user': user.toJson(),
      if (profile != null) 'profile': profile!.toJson(),
    };
  }

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    final profileJson = json['profile'];

    return AuthSession(
      accessToken: json['access_token']?.toString() ?? '',
      tokenType: json['token_type']?.toString() ?? 'Bearer',
      expiresIn: _toInt(json['expires_in']),
      user: userJson is Map<String, dynamic>
          ? AuthUser.fromJson(userJson)
          : AuthUser(id: '', email: '', role: ''),
      profile: profileJson is Map<String, dynamic>
          ? AuthProfile.fromJson(profileJson)
          : null,
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

class ProfileUpdateRequest {
  ProfileUpdateRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.kabupatenKota,
    required this.kecamatan,
    required this.nik,
    required this.birthDate,
    required this.gender,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String kabupatenKota;
  final String kecamatan;
  final String nik;
  final String birthDate;
  final String gender;

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'kabupaten_kota': kabupatenKota,
      'kecamatan': kecamatan,
      'nik': nik,
      'birth_date': birthDate,
      'gender': gender,
    };
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

  Future<AuthSession> login({required String email, required String password}) {
    return _postAuth(
      '/auth/login',
      body: {'email': email, 'password': password},
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

  Future<AuthProfile> getProfile() async {
    final decoded = await _authenticatedRequest('GET', '/profile');
    final data = decoded['data'];
    if (data is! Map<String, dynamic>) {
      throw ApiException('Format response profile tidak valid.');
    }

    final profile = AuthProfile.fromJson(data);
    _syncProfileToSession(profile);
    return profile;
  }

  Future<AuthProfile> updateProfile(ProfileUpdateRequest request) async {
    await _authenticatedRequest('PUT', '/profile', body: request.toJson());
    return getProfile();
  }

  Future<String> updateProfilePhoto(File file) async {
    final session = _requireSession();
    http.StreamedResponse response;

    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse('${ApiConfig.baseUrl}/profile/photo'),
      );
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = session.authorizationHeader;
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      response = await request.send();
    } catch (_) {
      throw ApiException('Tidak dapat mengunggah foto profile.');
    }

    final body = await response.stream.bytesToString();
    final decoded = _decodeResponse(body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        _errorMessage(decoded),
        statusCode: response.statusCode,
        fieldErrors: _fieldErrors(decoded),
      );
    }

    final photoUrl = decoded['data']?.toString() ?? '';
    final profile = currentSession?.profile;
    if (profile != null && photoUrl.isNotEmpty) {
      _syncProfileToSession(profile.copyWith(photoUrl: photoUrl));
    }

    return photoUrl;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _authenticatedRequest(
      'PUT',
      '/auth/change-password',
      body: {
        'password_lama': currentPassword,
        'password_baru': newPassword,
        'ulangi_password': confirmPassword,
      },
    );
  }

  Future<void> deleteAccount() async {
    await _authenticatedRequest('DELETE', '/auth/delete-account');
    clearSession();
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

  Future<Map<String, dynamic>> _authenticatedRequest(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final session = _requireSession();
    http.Response response;

    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$path');
      final headers = {
        'Accept': 'application/json',
        'Authorization': session.authorizationHeader,
        if (body != null) 'Content-Type': 'application/json',
      };
      final encodedBody = body == null ? null : jsonEncode(body);

      switch (method) {
        case 'GET':
          response = await _client.get(uri, headers: headers);
          break;
        case 'PUT':
          response = await _client.put(
            uri,
            headers: headers,
            body: encodedBody,
          );
          break;
        case 'DELETE':
          response = await _client.delete(uri, headers: headers);
          break;
        default:
          throw ApiException('Metode request tidak didukung.');
      }
    } catch (error) {
      if (error is ApiException) {
        rethrow;
      }
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

    return decoded;
  }

  AuthSession _requireSession() {
    final session = currentSession;
    if (session == null) {
      throw ApiException('Sesi login tidak ditemukan.');
    }
    return session;
  }

  void _syncProfileToSession(AuthProfile profile) {
    final session = currentSession;
    if (session == null) {
      return;
    }

    final email = profile.email.isNotEmpty ? profile.email : session.user.email;
    currentSession = session.copyWith(
      user: session.user.copyWith(email: email),
      profile: profile,
    );
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
