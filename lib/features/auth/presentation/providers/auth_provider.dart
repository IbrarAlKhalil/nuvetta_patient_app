import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_api.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/token_storage.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(AuthApi());
});

final authProvider = AsyncNotifierProvider<AuthNotifier, UserEntity?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<UserEntity?> {
  String? verificationToken;
  String? forgotPasswordToken;

  @override
  Future<UserEntity?> build() async {
    final accessToken = await TokenStorage.getAccessToken();
    if (accessToken == null) return null;

    final repository = ref.read(authRepositoryProvider);

    try {
      final user = await repository.getProfile();
      return user;
    } catch (_) {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null) return null;

      try {
        final refreshed = await repository.refreshToken(refreshToken);
        await TokenStorage.saveTokens(
          refreshed.accessToken,
          refreshed.refreshToken,
        );
        return refreshed.user;
      } catch (_) {
        await TokenStorage.clear();
        return null;
      }
    }
  }

  Future<void> login(String identifier, String password) async {
    state = const AsyncLoading();

    final repository = ref.read(authRepositoryProvider);
    try {
      final result = await repository.login(identifier, password);
      await TokenStorage.saveTokens(result.accessToken, result.refreshToken);
      state = AsyncData(result.user);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<String> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    state = const AsyncLoading();

    final repository = ref.read(authRepositoryProvider);
    try {
      final token = await repository.register(name, email, phone, password);
      verificationToken = token;
      state = const AsyncData(null);
      return token;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<UserEntity> verifyOtp(String code) async {
    if (verificationToken == null) {
      throw Exception('Verification token is missing. Please register first.');
    }

    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);
    try {
      final result = await repository.verifyOtp(verificationToken!, code);
      await TokenStorage.saveTokens(result.accessToken, result.refreshToken);
      verificationToken = null;
      state = AsyncData(result.user);
      return result.user;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<String> forgotPassword(String identifier) async {
    state = const AsyncLoading();

    final repository = ref.read(authRepositoryProvider);
    try {
      final token = await repository.forgotPassword(identifier);
      forgotPasswordToken = token;
      state = const AsyncData(null);
      return token;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> resetPassword(
    String token,
    String newPassword,
  ) async {
    state = const AsyncLoading();

    final repository = ref.read(authRepositoryProvider);
    try {
      await repository.resetPassword(token, newPassword);
      forgotPasswordToken = null;
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> logout() async {
    await TokenStorage.clear();
    state = const AsyncData(null);
  }
}
