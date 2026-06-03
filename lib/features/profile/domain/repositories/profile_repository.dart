

import 'package:file_picker/file_picker.dart';
import 'package:nuveta_patient_app/features/profile/data/models/profile_model.dart';
import 'package:nuveta_patient_app/features/profile/data/models/record_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();
  Future<ProfileModel> updateProfile({
    String? firstName,
    String? lastName,
    String? email,
    String? countryCode,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? zipCode,
  });
  Future<List<RecordModel>> getRecords();
  Future<RecordModel> addRecord({
    required String type,
    required String title,
    required String description,
    required DateTime date,
    PlatformFile? attachment,
  });
}
