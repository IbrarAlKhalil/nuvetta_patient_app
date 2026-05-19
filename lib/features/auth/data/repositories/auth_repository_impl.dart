import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;

  AuthRepositoryImpl(this.api);

  @override
  Future<UserEntity> login(String email, String password) async {
    final data = await api.login(email, password);

    return UserModel.fromJson(data['user']);
  }

  @override
  Future<UserEntity> register(
    String name,
    String email,
    String password,
  ) async {
    final data = await api.register(name, email, password);

    return UserModel.fromJson(data['user']);
  }
}
