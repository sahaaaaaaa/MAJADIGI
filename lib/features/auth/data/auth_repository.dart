import 'package:majadigi/features/auth/data/auth_local_storage.dart';
import 'package:majadigi/services/auth_service.dart';

class AuthRepository {
  AuthRepository({
    required AuthService authService,
    required AuthLocalStorage localStorage,
  }) : _authService = authService,
       _localStorage = localStorage;

  final AuthService _authService;
  final AuthLocalStorage _localStorage;

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final session = await _authService.login(email: email, password: password);

    await saveSession(session);
    return session;
  }

  Future<AuthSession> register({
    required RegisterRequest request,
    List<int> layananIds = const [],
  }) async {
    final session = await _authService.register(
      request: request,
      layananIds: layananIds,
    );

    await saveSession(session);
    return session;
  }

  Future<AuthSession?> restoreSession() async {
    try {
      final session = await _localStorage.readSession();

      if (session == null || session.accessToken.isEmpty) {
        AuthService.clearSession();
        return null;
      }

      AuthService.currentSession = session;
      return session;
    } catch (_) {
      await clearSession();
      return null;
    }
  }

  Future<void> saveSession(AuthSession session) async {
    AuthService.currentSession = session;

    try {
      await _localStorage.saveSession(session);
    } catch (_) {}
  }

  Future<void> clearSession() async {
    AuthService.clearSession();

    try {
      await _localStorage.clearSession();
    } catch (_) {}
  }

  Future<void> logout() async {
    await clearSession();
  }

  Future<void> deleteAccount() async {
    await _authService.deleteAccount();
    await clearSession();
  }
}
