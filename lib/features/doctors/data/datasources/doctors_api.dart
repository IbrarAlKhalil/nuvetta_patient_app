import 'package:nuveta_patient_app/features/doctors/models/doctor_model.dart';

import '../../../../core/mock/mock_doctors.dart';

class DoctorsApi {
  Future<List<DoctorModel>> fetchDoctors() async {
    await Future.delayed(const Duration(seconds: 2));

    return mockDoctors
        .map((e) => DoctorModel.fromJson(e))
        .toList();
  }
}