import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class AuthApi {
  final Dio dio = DioClient.dio;

  static Map<String, dynamic> _unwrap(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data;
    }
    return {};
  }

  /// Login with phone and password
  /// Returns: { requiresOtp: true, sessionId: "...", phone: "..." }
  Future<Map<String, dynamic>> loginWithPassword(
    String countryCode,
    String phone,
    String password,
  ) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'countryCode': countryCode,
          'phone': phone,
          'password': password,
        },
      );
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Login Error: ${e.type} - ${e.message}');
      print('URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
      rethrow;
    }
  }

  /// Verify OTP for login
  /// Returns: { access_token: "...", refresh_token: "...", user: {...} }
  Future<Map<String, dynamic>> verifyLoginOtp(
    String countryCode,
    String phone,
    String code,
  ) async {
    try {
      final response = await dio.post(
        '/auth/verify-otp',
        data: {
          'countryCode': countryCode,
          'phone': phone,
          'code': code,
        },
      );
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Verify Login OTP error: ${e.type} - ${e.message}');
      rethrow;
    }
  }

  /// Register with user details
  /// Returns: { requiresOtp: true, sessionId: "...", phone: "..." }
  Future<Map<String, dynamic>> registerWithPassword({
    required String fullName,
    required String countryCode,
    required String phone,
    required String password,
    required String role,
    String? email,
  }) async {
    try {
      final data = {
        'fullName': fullName,
        'countryCode': countryCode,
        'phone': phone,
        'password': password,
        'role': role,
      };
      if (email != null && email.isNotEmpty) {
        data['email'] = email;
      }

      final response = await dio.post(
        '/auth/register',
        data: data,
      );
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Register Error: ${e.type} - ${e.message}');
      print('📍 URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
      print('⏱️  Base URL: ${e.requestOptions.baseUrl}');
      print('🔴 Response status: ${e.response?.statusCode}');
      print('🔴 Response data: ${e.response?.data}');
      rethrow;
    }
  }

  /// Verify OTP for registration
  /// Returns: { access_token: "...", refresh_token: "...", user: {...}, userId: ... }
  Future<Map<String, dynamic>> verifyRegisterOtp(
    String countryCode,
    String phone,
    String code,
  ) async {
    try {
      final response = await dio.post(
        '/auth/verify-otp',
        data: {
          'countryCode': countryCode,
          'phone': phone,
          'code': code,
        },
      );
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Verify Register OTP error: ${e.type} - ${e.message}');
      rethrow;
    }
  }

  /// Resend OTP
  /// Returns: { success: true }
  Future<Map<String, dynamic>> resendOtp(
    String sessionId,
  ) async {
    try {
      final response = await dio.post(
        '/auth/resend-otp',
        data: {
          'sessionId': sessionId,
        },
      );
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Resend OTP error: ${e.type} - ${e.message}');
      rethrow;
    }
  }

  /// Forgot password - start recovery flow
  Future<Map<String, dynamic>> forgotPassword(
    String countryCode,
    String phone,
  ) async {
    try {
      final response = await dio.post(
        '/auth/forgot-password',
        data: {
          'countryCode': countryCode,
          'phone': phone,
        },
      );
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Forgot password error: ${e.type} - ${e.message}');
      rethrow;
    }
  }

  /// Verify OTP for password reset
  Future<Map<String, dynamic>> verifyOtp(
    String countryCode,
    String phone,
    String otp,
  ) async {
    try {
      final response = await dio.post(
        '/auth/verify-otp',
        data: {
          'countryCode': countryCode,
          'phone': phone,
          'code': otp,
        },
      );
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Verify OTP error: ${e.type} - ${e.message}');
      rethrow;
    }
  }

  /// Reset password
  Future<Map<String, dynamic>> resetPassword(
    String token,
    String password,
  ) async {
    try {
      final response = await dio.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'password': password,
        },
      );
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Reset password error: ${e.type} - ${e.message}');
      rethrow;
    }
  }
}

