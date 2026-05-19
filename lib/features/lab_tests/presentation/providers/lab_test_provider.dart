import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:nuveta_patient_app/features/lab_tests/data/repositories/lab_test_repository_impl.dart';
import 'package:nuveta_patient_app/features/lab_tests/domain/repositories/lab_test_repository.dart';

final labTestRepositoryProvider = Provider<LabTestRepository>((ref) {
  return LabTestRepositoryImpl();
});

final labTestsProvider = FutureProvider((ref) async {
  final repository = ref.watch(labTestRepositoryProvider);
  return repository.getLabTests();
});

final labBookingsProvider = FutureProvider((ref) async {
  final repository = ref.watch(labTestRepositoryProvider);
  return repository.getLabBookings();
});

final labBookingProvider = StateNotifierProvider<LabBookingNotifier, AsyncValue<void>>((ref) {
  final repository = ref.watch(labTestRepositoryProvider);
  return LabBookingNotifier(repository);
});

class LabBookingNotifier extends StateNotifier<AsyncValue<void>> {
  final LabTestRepository repository;

  LabBookingNotifier(this.repository) : super(const AsyncValue.data(null));

  Future<void> bookLabTest({
    required String testName,
    required DateTime bookingDate,
    required String collectionType,
    required String address,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repository.bookLabTest(
      testName: testName,
      bookingDate: bookingDate,
      collectionType: collectionType,
      address: address,
    ));
  }
}
