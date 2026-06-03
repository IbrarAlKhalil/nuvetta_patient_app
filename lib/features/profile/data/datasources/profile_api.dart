import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class ProfileApi {
  final Dio dio = DioClient.dio;

  static void _logDioError(String label, DioException e) {
    print('❌ $label: ${e.message}');
    if (e.response != null) {
      print('   Status: ${e.response?.statusCode}');
      print('   Response: ${e.response?.data}');
    }
    print('   Request path: ${e.requestOptions.path}');

    final requestData = e.requestOptions.data;
    if (requestData is FormData) {
      print('   Request FormData fields: ${requestData.fields.map((f) => '${f.key}=${f.value}').join(', ')}');
      print('   Request FormData files: ${requestData.files.map((f) => '${f.key}=${f.value.filename}').join(', ')}');
    } else {
      print('   Request data: $requestData');
    }
  }

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
      _logDioError('Get profile error', e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> payload) async {
    try {
      final response = await dio.patch('/profile', data: payload);
      return _unwrap(response);
    } on DioException catch (e) {
      _logDioError('Update profile error', e);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getRecords() async {
    try {
      final response = await dio.get('/profile/records');
      return _unwrapList(response);
    } on DioException catch (e) {
      _logDioError('Get records error', e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> addRecord(dynamic payload) async {
    try {
      final response = await dio.post('/profile/records', data: payload);
      return _unwrap(response);
    } on DioException catch (e) {
      _logDioError('Add record error', e);
      rethrow;
    }
  }
}
