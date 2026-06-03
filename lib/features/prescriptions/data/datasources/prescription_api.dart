import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class PrescriptionApi {
  final Dio dio = DioClient.dio;

  List<Map<String, dynamic>> _unwrapList(Response response) {
    final data = response.data;
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
    if (data is Map<String, dynamic> && data['prescriptions'] is List) {
      return (data['prescriptions'] as List).cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getPrescriptions() async {
    try {
      final response = await dio.get('/prescriptions');
      return _unwrapList(response);
    } on DioException catch (e) {
      print('❌ Prescription fetch error: ${e.message}');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getPrescriptionsByAppointment(
    String appointmentId,
  ) async {
    try {
      final response = await dio.get('/prescriptions/$appointmentId');
      return _unwrapList(response);
    } on DioException catch (e) {
      print('❌ Prescription fetch error for appointment: ${e.message}');
      rethrow;
    }
  }
}