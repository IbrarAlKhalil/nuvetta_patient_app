import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class AuthApi {
  final Dio dio = DioClient.dio;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {"email": email, "password": password},
      );
      return response.data ?? {};
    } on DioException catch (e) {
      print('❌ Login Error: ${e.type} - ${e.message}');
      print('URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: {"name": name, "email": email, "password": password},
      );
      return response.data ?? {};
    } on DioException catch (e) {
      print('❌ Register Error: ${e.type} - ${e.message}');
      print('URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
      rethrow;
    }
  }
}
