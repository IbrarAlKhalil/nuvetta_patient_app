import 'user_entity.dart';

class AuthResult {
  final UserEntity user;
  final String accessToken;

  AuthResult({
    required this.user,
    required this.accessToken,
  });
}
