import '../datasources/prescription_api.dart';
import '../../domain/repositories/prescription_repository.dart';
import '../models/prescription_model.dart';

class PrescriptionRepositoryImpl implements PrescriptionRepository {
  final PrescriptionApi api;

  PrescriptionRepositoryImpl([PrescriptionApi? api]) : api = api ?? PrescriptionApi();

  @override
  Future<List<PrescriptionModel>> getPrescriptions() async {
    final result = await api.getPrescriptions();
    return result.map((data) => PrescriptionModel.fromJson(data)).toList();
  }

  @override
  Future<PrescriptionModel> getPrescriptionById(String id) async {
    final prescriptions = await getPrescriptions();
    return prescriptions.firstWhere((p) => p.id == id);
  }

  @override
  Future<void> requestRefill(String prescriptionId) async {
    // There is no refill endpoint defined in clinic-backend docs,
    // so preserve the existing app behavior while keeping the UI responsive.
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
