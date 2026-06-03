

import 'package:nuveta_patient_app/features/appointments/data/models/appointment_model.dart';

abstract class AppointmentRepository {
  Future<List<AppointmentModel>> getAppointments();
  Future<AppointmentModel> getAppointmentById(String id);
  Future<AppointmentModel> createAppointment(Map<String, dynamic> payload);
}
