import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class AppointmentsApi {
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
    if (data is Map<String, dynamic> && data['appointments'] is List) {
      return (data['appointments'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getAppointments() async {
    try {
      final response = await dio.get('/appointments');
      return _unwrapList(response);
    } on DioException catch (e) {
      print('❌ Get appointments error: ${e.message}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAppointmentById(String id) async {
    try {
      final response = await dio.get('/appointments/$id');
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Get appointment by id error: ${e.message}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createAppointment(Map<String, dynamic> payload) async {
    try {
      final response = await dio.post('/appointments', data: payload);
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Create appointment error: ${e.message}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> updateAppointmentStatus(
    String appointmentId,
    String status,
  ) async {
    try {
      final response = await dio.patch(
        '/appointments/$appointmentId/status',
        data: {'status': status},
      );
      return _unwrap(response);
    } on DioException catch (e) {
      print('❌ Update appointment status error: ${e.message}');
      rethrow;
    }
  }
}