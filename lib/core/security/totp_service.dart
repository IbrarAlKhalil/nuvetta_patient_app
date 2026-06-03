import 'dart:math';
import 'package:otp/otp.dart';

class TotpService {
  static const _base32Alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

  /// Generate a random Base32 secret suitable for TOTP
  static String generateSecret([int length = 16]) {
    final rand = Random.secure();
    final buffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      buffer.write(_base32Alphabet[rand.nextInt(_base32Alphabet.length)]);
    }
    return buffer.toString();
  }

  /// Create an otpauth:// URI for QR code scanning by authenticator apps
  static String buildOtpAuthUri({
    required String secret,
    required String issuer,
    required String accountName,
    int digits = 6,
    int interval = 30,
  }) {
    final label = Uri.encodeComponent('$issuer:$accountName');
    final params = {
      'secret': secret,
      'issuer': issuer,
      'digits': digits.toString(),
      'period': interval.toString(),
      'algorithm': 'SHA1',
    };
    final query = params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
    return 'otpauth://totp/$label?$query';
  }

  /// Verify a TOTP code against a secret (allows a small time window)
  static bool verifyCode({
    required String secret,
    required String code,
    int interval = 30,
    int length = 6,
    int allowableSkew = 1, // allow one interval before/after
  }) {
    try {
        final now = DateTime.now().toUtc();
    final millis = now.millisecondsSinceEpoch;
    final current = OTP.generateTOTPCodeString(
      secret,
      millis,
      interval: interval,
      length: length,
      algorithm: Algorithm.SHA1,
      isGoogle: true,
    );
    if (current == code) return true;

    // check previous and next windows
    for (var i = 1; i <= allowableSkew; i++) {
      final prevMillis = now.subtract(Duration(seconds: interval * i)).millisecondsSinceEpoch;
      final prev = OTP.generateTOTPCodeString(
        secret,
        prevMillis,
        interval: interval,
        length: length,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );
      if (prev == code) return true;

      final nextMillis = now.add(Duration(seconds: interval * i)).millisecondsSinceEpoch;
      final next = OTP.generateTOTPCodeString(
        secret,
        nextMillis,
        interval: interval,
        length: length,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );
      if (next == code) return true;
    }
      return false;
    } catch (_) {
      return false;
    }
  }
}
