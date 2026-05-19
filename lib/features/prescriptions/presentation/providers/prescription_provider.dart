import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nuveta_patient_app/features/prescriptions/data/repositories/prescription_repository_impl.dart';
import 'package:nuveta_patient_app/features/prescriptions/domain/repositories/prescription_repository.dart';


final prescriptionRepositoryProvider = Provider<PrescriptionRepository>((ref) {
  return PrescriptionRepositoryImpl();
});

final prescriptionsProvider = FutureProvider((ref) async {
  final repository = ref.watch(prescriptionRepositoryProvider);
  return repository.getPrescriptions();
});

final prescriptionRefillProvider = StateNotifierProvider<RefillNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(prescriptionRepositoryProvider);
  return RefillNotifier(repository);
});

class RefillNotifier extends StateNotifier<AsyncValue<void>> {
  final PrescriptionRepository repository;

  RefillNotifier(this.repository) : super(const AsyncValue.data(null));

  Future<void> requestRefill(String prescriptionId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repository.requestRefill(prescriptionId));
  }
}
