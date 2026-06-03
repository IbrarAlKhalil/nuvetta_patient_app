import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TotpStorage {
  static const _storage = FlutterSecureStorage();
  static const _totpSecretKey = 'totp_secret';

  static Future<void> saveSecret(String secret) async {
    await _storage.write(key: _totpSecretKey, value: secret);
  }

  static Future<String?> getSecret() async {
    return await _storage.read(key: _totpSecretKey);
  }

  static Future<bool> hasSecret() async {
    return (await getSecret()) != null;
  }

  static Future<void> clearSecret() async {
    await _storage.delete(key: _totpSecretKey);
  }
}
