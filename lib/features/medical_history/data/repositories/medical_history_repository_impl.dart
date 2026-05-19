import 'package:nuveta_patient_app/core/mock/mock_data.dart';
import '../../domain/repositories/medical_history_repository.dart';
import '../models/medical_history_model.dart';

class MedicalHistoryRepositoryImpl implements MedicalHistoryRepository {
  @override
  Future<List<MedicalHistoryModel>> getMedicalHistory() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    final mockData = MockDataGenerator.generateMedicalHistory();
    return mockData.map((data) => MedicalHistoryModel.fromJson(data)).toList();
  }

  @override
  Future<MedicalHistoryModel> addMedicalHistory(MedicalHistoryModel history) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return history;
  }

  @override
  Future<void> updateMedicalHistory(MedicalHistoryModel history) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> deleteMedicalHistory(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
