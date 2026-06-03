import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class ProfileApi {
  final Dio dio = DioClient.dio;

  static Map<String, dynamic> _unwrap(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data;
    }
    return {};
  }

  static List<Map<String, dynamic>> _unwrapList(Response response) {
    final data = response.data;
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    if (data is Map<String, dynamic> && data['records'] is List) {
      return (data['records'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await dio.get('/profile');
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Get profile error: ${e.message}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> payload) async {
    try {
      final response = await dio.patch('/profile', data: payload);
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Update profile error: ${e.message}');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getRecords() async {
    try {
      final response = await dio.get('/profile/records');
      return _unwrapList(response);
    } on DioException catch (e) {
      print('❌ Get records error: ${e.message}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addRecord(dynamic payload) async {
    try {
      final response = await dio.post('/profile/records', data: payload);
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Add record error: ${e.message}');
      rethrow;
    }
  }
}
