import 'package:nuveta_patient_app/core/mock/mock_data.dart';
import '../../domain/repositories/prescription_repository.dart';
import '../models/prescription_model.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  @override
  Future<List<PrescriptionModel>> getPrescriptions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final mockData = MockDataGenerator.generatePrescriptions();
    return mockData.map((data) => PrescriptionModel.fromJson(data)).toList();
  }

  @override
  Future<PrescriptionModel> getPrescriptionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final mockData = MockDataGenerator.generatePrescriptions();
    return PrescriptionModel.fromJson(mockData.firstWhere((p) => p['id'] == id));
  }

  @override
  Future<void> requestRefill(String prescriptionId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock successful refill request
  }
}
