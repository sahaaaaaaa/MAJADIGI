import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:majadigi/features/auth/data/auth_local_storage.dart';
import 'package:majadigi/features/auth/data/auth_repository.dart';
import 'package:majadigi/features/auth/data/auth_service.dart';

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return FlutterSecureStorage();
});

final authServiceProvider = Provider<AuthService>((ref) {
  final service = AuthService();
  ref.onDispose(service.dispose);
  return service;
});

final authLocalStorageProvider = Provider<AuthLocalStorage>((ref) {
  return AuthLocalStorage(ref.read(flutterSecureStorageProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    authService: ref.read(authServiceProvider),
    localStorage: ref.read(authLocalStorageProvider),
  );
});

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthSession?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async {
    return ref.read(authRepositoryProvider).restoreSession();
  }

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading<AuthSession?>();

    try {
      final session = await ref
          .read(authRepositoryProvider)
          .login(email: email, password: password);
      state = AsyncData<AuthSession?>(session);
      return session;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<AuthSession> register({
    required RegisterRequest request,
    List<int> layananIds = const [],
  }) async {
    state = const AsyncLoading<AuthSession?>();

    try {
      final session = await ref
          .read(authRepositoryProvider)
          .register(request: request, layananIds: layananIds);

      state = AsyncData<AuthSession?>(session);
      return session;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData<AuthSession?>(null);
  }

  Future<void> deleteAccount() async {
    await ref.read(authRepositoryProvider).deleteAccount();
    state = const AsyncData<AuthSession?>(null);
  }
}
