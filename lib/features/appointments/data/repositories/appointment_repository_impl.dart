import '../../domain/repositories/appointment_repository.dart';
import '../datasources/appointments_api.dart';
import '../models/appointment_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final AppointmentsApi api;

  AppointmentRepositoryImpl([AppointmentsApi? api]) : api = api ?? AppointmentsApi();

  @override
  Future<List<AppointmentModel>> getAppointments() async {
    final result = await api.getAppointments();
    return result.map((json) => AppointmentModel.fromJson(json)).toList();
  }

  @override
  Future<AppointmentModel> getAppointmentById(String id) async {
    final result = await api.getAppointmentById(id);
    return AppointmentModel.fromJson(result);
  }

  @override
  Future<AppointmentModel> createAppointment(Map<String, dynamic> payload) async {
    final result = await api.createAppointment(payload);
    return AppointmentModel.fromJson(result);
  }
}
