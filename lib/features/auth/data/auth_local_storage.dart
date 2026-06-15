import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:majadigi/features/auth/data/auth_service.dart';

class AuthLocalStorage {
  AuthLocalStorage(this._storage);

  static const String _sessionKey = 'auth_session';

  final FlutterSecureStorage _storage;

  Future<void> saveSession(AuthSession session) async {
    await _storage.write(key: _sessionKey, value: jsonEncode(session.toJson()));
  }

  Future<AuthSession?> readSession() async {
    final raw = await _storage.read(key: _sessionKey);
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        final session = AuthSession.fromJson(decoded);
        if (session.accessToken.isNotEmpty) {
          return session;
        }
      }
    } catch (_) {}

    await clearSession();
    return null;
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _sessionKey);
  }
}
