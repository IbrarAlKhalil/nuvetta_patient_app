import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nuveta_patient_app/features/medical_history/data/repositories/medical_history_repository_impl.dart';
import 'package:nuveta_patient_app/features/medical_history/domain/repositories/medical_history_repository.dart';


final medicalHistoryRepositoryProvider = Provider<MedicalHistoryRepository>((ref) {
  return MedicalHistoryRepositoryImpl();
});

final medicalHistoryProvider = FutureProvider((ref) async {
  final repository = ref.watch(medicalHistoryRepositoryProvider);
  return repository.getMedicalHistory();
});
