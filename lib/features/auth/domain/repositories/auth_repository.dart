import '../entities/auth_result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<AuthResult> login(String identifier, String password);
  Future<String> register(
    String name,
    String email,
    String phone,
    String password,
  );
  Future<AuthResult> verifyOtp(String token, String code);
  Future<String> forgotPassword(String identifier);
  Future<void> resetPassword(String token, String newPassword);
  Future<AuthResult> refreshToken(String refreshToken);
  Future<UserEntity> getProfile();
}
