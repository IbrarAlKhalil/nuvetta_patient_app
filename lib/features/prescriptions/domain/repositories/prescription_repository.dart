import 'package:nuveta_patient_app/features/prescriptions/data/models/prescription_model.dart';


abstract class PrescriptionRepository {
  Future<List<PrescriptionModel>> getPrescriptions();
  Future<PrescriptionModel> getPrescriptionById(String id);
  Future<void> requestRefill(String prescriptionId);
}
