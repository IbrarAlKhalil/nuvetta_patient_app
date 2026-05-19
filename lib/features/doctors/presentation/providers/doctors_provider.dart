import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nuveta_patient_app/features/doctors/data/datasources/doctors_api.dart';
import 'package:nuveta_patient_app/features/doctors/models/doctor_model.dart';


final doctorsProvider =
    FutureProvider<List<DoctorModel>>((ref) async {
  final api = DoctorsApi();
  return api.fetchDoctors();
});