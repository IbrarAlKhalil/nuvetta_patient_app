import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
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
  }
];

/// =======================
/// PROVIDER
/// =======================

final authProvider =
    AsyncNotifierProvider<AuthNotifier, UserEntity?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<UserEntity?> {
  @override
  Future<UserEntity?> build() async {
    return null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    await Future.delayed(const Duration(seconds: 2));

    try {
      final user = mockUsers.firstWhere(
        (u) =>
            u['email'] == email &&
            u['password'] == password,
        orElse: () => {},
      );

      if (user.isEmpty) {
        throw Exception("Invalid credentials");
      }

      final userEntity = UserEntity(
        id: user['id'].toString(),
        name: user['name'].toString(),
        email: user['email'].toString(),
        role: user['role'].toString(),
      );

      await TokenStorage.saveToken(userEntity.id);

      state = AsyncData(userEntity);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    state = const AsyncLoading();

    await Future.delayed(const Duration(seconds: 2));

    try {
      final exists = mockUsers.any(
        (u) => u['email'] == email,
      );

      if (exists) {
        throw Exception("User already exists");
      }

      final newUser = {
        "id": DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
        "name": name,
        "email": email,
        "password": password,
        "role": "patient",
      };

      mockUsers.add(newUser);

      final userEntity = UserEntity(
        id: newUser['id'].toString(),
        name: newUser['name'].toString(),
        email: newUser['email'].toString(),
        role: newUser['role'].toString(),
      );

      await TokenStorage.saveToken(userEntity.id);

      state = AsyncData(userEntity);
    } catch (e, st) {
      state = AsyncError(e, st);
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

  // 🔥 mock restore user (replace with real API later)
  state = AsyncValue.data(
    UserEntity(
      id: "1",
      name: "Restored User",
      email: "saved@user.com",
      role: "patient",
    ),
  );
}
}