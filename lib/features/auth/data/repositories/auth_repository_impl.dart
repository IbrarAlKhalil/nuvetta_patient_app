import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;

  AuthRepositoryImpl(this.api);

  @override
  Future<AuthResult> login(String identifier, String password) async {
    final result = await api.login(identifier, password);
    final accessToken = result['accessToken'] as String? ?? '';
    final refreshToken = result['refreshToken'] as String? ?? '';
    final userJson = result['user'] as Map<String, dynamic>? ?? result;
    final user = UserModel.fromJson(userJson);

    return AuthResult(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<String> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    final result = await api.register(name, email, phone, password);
    final token = result['verificationToken'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception('Registration succeeded but verification token is missing.');
    }
    return token;
  }

  @override
  Future<AuthResult> verifyOtp(String token, String code) async {
    final result = await api.verifyOtp(token, code);
    final accessToken = result['accessToken'] as String? ?? '';
    final refreshToken = result['refreshToken'] as String? ?? '';
    final userJson = result['user'] as Map<String, dynamic>? ?? result;
    final user = UserModel.fromJson(userJson);

    return AuthResult(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<String> forgotPassword(String identifier) async {
    final result = await api.forgotPassword(identifier);
    final token = result['verificationToken'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception('Forgot password request succeeded but token is missing.');
    }
    return token;
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    await api.resetPassword(token, newPassword);
  }

  @override
  Future<AuthResult> refreshToken(String refreshToken) async {
    final result = await api.refreshToken(refreshToken);
    final accessToken = result['accessToken'] as String? ?? '';
    final refreshTokenResult = result['refreshToken'] as String? ?? '';
    final userJson = result['user'] as Map<String, dynamic>? ?? result;
    final user = UserModel.fromJson(userJson);
    return AuthResult(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshTokenResult,
    );
  }

  @override
  Future<UserEntity> getProfile() async {
    final result = await api.getProfile();
    return UserModel.fromJson(result);
  }
}
