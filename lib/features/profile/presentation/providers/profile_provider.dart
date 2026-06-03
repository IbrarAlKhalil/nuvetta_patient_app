import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/record_model.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl();
});

final profileProvider = FutureProvider<ProfileModel>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfile();
});

final profileRecordsProvider = FutureProvider<List<RecordModel>>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getRecords();
});
