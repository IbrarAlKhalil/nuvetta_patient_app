import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/appointment_model.dart';
import '../../data/repositories/appointment_repository_impl.dart';
import '../../domain/repositories/appointment_repository.dart';

final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return AppointmentRepositoryImpl();
});

final appointmentsProvider = FutureProvider<List<AppointmentModel>>((ref) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getAppointments();
});

final appointmentDetailProvider = FutureProvider.family<AppointmentModel, String>((ref, appointmentId) async {
  final repository = ref.watch(appointmentRepositoryProvider);
  return repository.getAppointmentById(appointmentId);
});
