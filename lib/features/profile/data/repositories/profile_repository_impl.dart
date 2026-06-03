import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_api.dart';
import '../models/profile_model.dart';
import '../models/record_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileApi api;

  ProfileRepositoryImpl([ProfileApi? api]) : api = api ?? ProfileApi();

  @override
  Future<ProfileModel> getProfile() async {
    final result = await api.getProfile();
    return ProfileModel.fromJson(result);
  }

  @override
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
  }) async {
    final payload = <String, dynamic>{};
    if (firstName != null) payload['firstName'] = firstName;
    if (lastName != null) payload['lastName'] = lastName;
    if (email != null) payload['email'] = email;
    if (countryCode != null) payload['countryCode'] = countryCode;
    if (phone != null) payload['phone'] = phone;
    if (address != null) payload['address'] = address;
    if (city != null) payload['city'] = city;
    if (state != null) payload['state'] = state;
    if (zipCode != null) payload['zipCode'] = zipCode;

    final result = await api.updateProfile(payload);
    return ProfileModel.fromJson(result);
  }

  @override
  Future<List<RecordModel>> getRecords() async {
    final result = await api.getRecords();
    return result.map((json) => RecordModel.fromJson(json)).toList();
  }

  @override
  Future<RecordModel> addRecord({
    required String type,
    required String title,
    required String description,
    required DateTime date,
    PlatformFile? attachment,
  }) async {
    final payload = <String, dynamic>{
      'type': type,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
    };

    final dynamic data;
    if (attachment != null) {
      final MultipartFile filePart = attachment.bytes != null
          ? MultipartFile.fromBytes(
              attachment.bytes!,
              filename: attachment.name,
            )
          : await MultipartFile.fromFile(
              attachment.path!,
              filename: attachment.name,
            );
      data = FormData.fromMap({
        ...payload,
        'file': filePart,
      });
    } else {
      data = payload;
    }

    final result = await api.addRecord(data);
    return RecordModel.fromJson(result);
  }
}
