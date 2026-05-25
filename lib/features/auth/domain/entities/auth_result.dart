import 'user_entity.dart';

class AuthResult {
  final UserEntity user;
  final String accessToken;
  final String refreshToken;

  AuthResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });
}
