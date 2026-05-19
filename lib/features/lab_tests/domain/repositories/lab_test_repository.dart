import '../entities/lab_test_entity.dart';

abstract class LabTestRepository {
  Future<List<LabTestEntity>> getLabTests();
  Future<List<LabBookingEntity>> getLabBookings();
  Future<LabBookingEntity> bookLabTest({
    required String testName,
    required DateTime bookingDate,
    required String collectionType,
    required String address,
  });
  Future<void> cancelLabBooking(String bookingId);
}
