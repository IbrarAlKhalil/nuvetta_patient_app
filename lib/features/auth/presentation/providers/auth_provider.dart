import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_api.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/token_storage.dart';

/// =======================
/// MOCK DATA (INSIDE SAME FILE)
/// =======================

final mockUsers = [
  {
    "id": "1",
    "name": "Ibrar Ghani",
    "email": "ibrar@gmail.com",
    "password": "123456",
    "role": "patient",
  },
];

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(AuthApi());
});

/// =======================
/// PROVIDER
/// =======================

final authProvider = AsyncNotifierProvider<AuthNotifier, UserEntity?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    final token = await TokenStorage.getToken();
    if (token == null) return null;

    final existingUser = mockUsers.firstWhere(
      (u) => u['id'] == token,
      orElse: () => {},
    );

    if (existingUser.isNotEmpty) {
      return UserEntity(
        id: existingUser['id'].toString(),
        name: existingUser['name'].toString(),
        email: existingUser['email'].toString(),
        role: existingUser['role'].toString(),
      );
    }

    return UserEntity(
      id: token,
      name: 'Patient',
      email: 'restored@patient.app',
      role: 'patient',
    );
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    await Future.delayed(const Duration(seconds: 2));

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.login(email, password);
      await TokenStorage.saveToken(user.id);
      state = AsyncData(user);
    } catch (error, stackTrace) {
      final user = mockUsers.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => {},
      );

      if (user.isEmpty) {
        state = AsyncError(error, stackTrace);
        return;
      }

      final fallbackUser = UserEntity(
        id: user['id'].toString(),
        name: user['name'].toString(),
        email: user['email'].toString(),
        role: user['role'].toString(),
      );

      await TokenStorage.saveToken(fallbackUser.id);
      state = AsyncData(fallbackUser);
    }
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncLoading();

    await Future.delayed(const Duration(seconds: 2));

    try {
      final repository = ref.read(authRepositoryProvider);
      final user = await repository.register(name, email, password);
      await TokenStorage.saveToken(user.id);
      state = AsyncData(user);
    } catch (error, stackTrace) {
      final exists = mockUsers.any((u) => u['email'] == email);

      if (exists) {
        state = AsyncError(Exception("User already exists"), stackTrace);
        return;
      }

      final newUser = {
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "name": name,
        "email": email,
        "password": password,
        "role": "patient",
      };

      mockUsers.add(newUser);

      final fallbackUser = UserEntity(
        id: newUser['id'].toString(),
        name: newUser['name'].toString(),
        email: newUser['email'].toString(),
        role: newUser['role'].toString(),
      );

      await TokenStorage.saveToken(fallbackUser.id);
      state = AsyncData(fallbackUser);
    }
  }

  Future<void> logout() async {
    await TokenStorage.clear();
    state = const AsyncData(null);
  }

  Future<void> initAuth() async {
    final token = await TokenStorage.getToken();

    if (token == null) {
      state = const AsyncValue.data(null);
      return;
    }

    final existingUser = mockUsers.firstWhere(
      (u) => u['id'] == token,
      orElse: () => {},
    );

    final restoredUser = existingUser.isNotEmpty
        ? UserEntity(
            id: existingUser['id'].toString(),
            name: existingUser['name'].toString(),
            email: existingUser['email'].toString(),
            role: existingUser['role'].toString(),
          )
        : UserEntity(
            id: token,
            name: 'Patient',
            email: 'restored@patient.app',
            role: 'patient',
          );

    state = AsyncValue.data(restoredUser);
  }
}
