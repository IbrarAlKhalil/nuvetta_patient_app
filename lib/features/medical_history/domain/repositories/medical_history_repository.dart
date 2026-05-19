import 'package:nuveta_patient_app/features/medical_history/data/models/medical_history_model.dart';


abstract class MedicalHistoryRepository {
  Future<List<MedicalHistoryModel>> getMedicalHistory();
  Future<MedicalHistoryModel> addMedicalHistory(MedicalHistoryModel history);
  Future<void> updateMedicalHistory(MedicalHistoryModel history);
  Future<void> deleteMedicalHistory(String id);
}
