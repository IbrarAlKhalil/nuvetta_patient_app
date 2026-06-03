import '../entities/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult> login(
    String countryCode,
    String phone,
    String password, {
    String? otp,
  });

  Future<int> register({
    required String fullName,
    required String countryCode,
    required String phone,
    required String password,
    required String role,
    String? email,
  });

  Future<void> forgotPassword(String countryCode, String phone);
  Future<String> verifyOtp(String countryCode, String phone, String otp);
  Future<void> resetPassword(String token, String password);
}
