import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class AuthApi {
  final Dio dio = DioClient.dio;

  static Map<String, dynamic> _unwrap(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      final payload = data['data'];
      if (payload is Map<String, dynamic>) {
        return payload;
      }
      return data;
    }
    return {};
  }

  Future<Map<String, dynamic>> login(
    String identifier,
    String password,
  ) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'identifier': identifier,
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

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
        },
      );
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Register Error: ${e.type} - ${e.message}');
      print('URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> verifyOtp(
    String token,
    String code,
  ) async {
    try {
      final response = await dio.post(
        '/auth/verify-otp',
        data: {
          'token': token,
          'code': code,
        },
      );
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Verify OTP Error: ${e.type} - ${e.message}');
      print('URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String identifier) async {
    try {
      final response = await dio.post(
        '/auth/forgot-password',
        data: {'identifier': identifier},
      );
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Forgot Password Error: ${e.type} - ${e.message}');
      print('URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
      rethrow;
    }
  }

  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await dio.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      print('❌ Reset Password Error: ${e.type} - ${e.message}');
      print('URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Refresh Token Error: ${e.type} - ${e.message}');
      print('URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await dio.get('/auth/me');
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Get Profile Error: ${e.type} - ${e.message}');
      print('URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
      rethrow;
    }
  }
}
