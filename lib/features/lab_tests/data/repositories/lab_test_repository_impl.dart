import 'package:nuveta_patient_app/core/mock/mock_data.dart';
import '../../domain/repositories/lab_test_repository.dart';
import '../models/lab_test_model.dart';

class LabTestRepositoryImpl implements LabTestRepository {
  @override
  Future<List<LabTestModel>> getLabTests() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final mockData = MockDataGenerator.generateLabResults();
    return mockData.map((data) => LabTestModel.fromJson(data)).toList();
  }

  @override
  Future<List<LabBookingModel>> getLabBookings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final mockData = MockDataGenerator.generateLabBookings();
    return mockData.map((data) => LabBookingModel.fromJson(data)).toList();
  }

  @override
  Future<LabBookingModel> bookLabTest({
    required String testName,
    required DateTime bookingDate,
    required String collectionType,
    required String address,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock successful booking
    const uuid = 'uuid.v4()';
    return LabBookingModel(
      id: uuid,
      testName: testName,
      bookingDate: bookingDate,
      status: 'confirmed',
      collectionType: collectionType,
      address: address,
      labName: 'City Diagnostic Lab',
      estimatedCost: 75.0,
      instructions: 'Fast for 8 hours before test',
    );
  }

  @override
  Future<void> cancelLabBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
