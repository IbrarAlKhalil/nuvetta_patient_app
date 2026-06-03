import '../../domain/entities/auth_result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api.dart';
import '../models/user_model.dart';

class LoginWithPasswordResult {
  final String? accessToken;
  final UserEntity? user;
  final LoginOtpRequiredResult? otpResult;

  LoginWithPasswordResult({this.accessToken, this.user, this.otpResult})
      : assert(accessToken != null || otpResult != null,
            'Either accessToken or otpResult must be provided');

  bool get requiresOtp => otpResult != null;
}

class RegisterWithPasswordResult {
  final String? accessToken;
  final UserEntity? user;
  final RegisterOtpRequiredResult? otpResult;
  final String? message;

  RegisterWithPasswordResult({this.accessToken, this.user, this.otpResult, this.message})
      : assert(accessToken != null || otpResult != null || message != null,
            'Either accessToken, otpResult, or message must be provided');

  bool get requiresOtp => otpResult != null;
  bool get isDirectSuccess => accessToken != null || (message != null && otpResult == null);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;

  AuthRepositoryImpl(this.api);

  /// Login with password - supports direct login or OTP requirement
  Future<LoginWithPasswordResult> loginWithPassword(
    String countryCode,
    String phone,
    String password,
  ) async {
    final result = await api.loginWithPassword(countryCode, phone, password);

    final accessToken = result['access_token'] as String? ?? result['token'] as String?;
    final userData = result['user'] as Map<String, dynamic>?;
    final requiresOtp = result['requiresOtp'] as bool? ?? false;
    final sessionId = result['sessionId'] as String?;

    if (accessToken != null) {
      UserEntity? user;
      if (userData != null) {
        user = UserModel(
          id: userData['id']?.toString() ?? userData['phone']?.toString() ?? '',
          email: userData['email']?.toString() ?? '',
          name: userData['fullName']?.toString() ?? userData['name']?.toString() ?? '',
          phone: userData['phone']?.toString() ?? '',
          role: userData['role']?.toString() ?? 'PATIENT',
        );
      }

      return LoginWithPasswordResult(
        accessToken: accessToken,
        user: user,
      );
    }

    if (requiresOtp && sessionId != null) {
      return LoginWithPasswordResult(
        otpResult: LoginOtpRequiredResult(
          sessionId: sessionId,
          phone: phone,
          countryCode: countryCode,
        ),
      );
    }

    throw Exception('Login failed or unexpected response format');
  }

  /// Verify OTP for login
  Future<AuthResult> verifyLoginOtp(
    String countryCode,
    String phone,
    String code,
  ) async {
    final result = await api.verifyLoginOtp(countryCode, phone, code);
    
    final accessToken = result['access_token'] as String? ?? result['token'] as String? ?? '';
    final userData = result['user'] as Map<String, dynamic>?;

    if (accessToken.isEmpty || userData == null) {
      throw Exception('OTP verification failed: No access token or user data received');
    }

    final user = UserModel(
      id: userData['id']?.toString() ?? userData['phone']?.toString() ?? '',
      email: userData['email']?.toString() ?? '',
      name: userData['fullName']?.toString() ?? userData['name']?.toString() ?? '',
      phone: userData['phone']?.toString() ?? '',
      role: userData['role']?.toString() ?? 'PATIENT',
    );

    return AuthResult(
      user: user,
      accessToken: accessToken,
    );
  }

  /// Register with password - supports direct creation, OTP flow, or immediate auth
  Future<RegisterWithPasswordResult> registerWithPassword({
    required String fullName,
    required String countryCode,
    required String phone,
    required String password,
    required String role,
    String? email,
  }) async {
    final result = await api.registerWithPassword(
      fullName: fullName,
      countryCode: countryCode,
      phone: phone,
      password: password,
      role: role,
      email: email,
    );

    final accessToken = result['access_token'] as String? ?? result['token'] as String?;
    final userData = result['user'] as Map<String, dynamic>?;
    final requiresOtp = result['requiresOtp'] as bool? ?? false;
    final sessionId = result['sessionId'] as String? ?? result['registrationId'] as String? ?? result['session_id'] as String?;
    final message = result['message'] as String?;

    if (accessToken != null) {
      UserEntity? user;
      if (userData != null) {
        user = UserModel(
          id: userData['id']?.toString() ?? userData['phone']?.toString() ?? '',
          email: userData['email']?.toString() ?? '',
          name: userData['fullName']?.toString() ?? userData['name']?.toString() ?? '',
          phone: userData['phone']?.toString() ?? '',
          role: userData['role']?.toString() ?? 'PATIENT',
        );
      }

      return RegisterWithPasswordResult(
        accessToken: accessToken,
        user: user,
        message: message,
      );
    }

    if (requiresOtp && sessionId != null) {
      return RegisterWithPasswordResult(
        otpResult: RegisterOtpRequiredResult(
          countryCode: countryCode,
          phone: phone,
          registrationId: sessionId,
        ),
        message: message,
      );
    }

    return RegisterWithPasswordResult(
      message: message ?? 'Registration completed successfully',
    );
  }

  /// Verify OTP for registration
  Future<AuthResult> verifyRegisterOtp(
    String countryCode,
    String phone,
    String code,
  ) async {
    final result = await api.verifyRegisterOtp(countryCode, phone, code);
    
    final accessToken = result['access_token'] as String? ?? result['token'] as String? ?? '';
    final userData = result['user'] as Map<String, dynamic>?;

    if (accessToken.isEmpty || userData == null) {
      throw Exception('OTP verification failed: No access token or user data received');
    }

    final user = UserModel(
      id: userData['id']?.toString() ?? userData['phone']?.toString() ?? '',
      email: userData['email']?.toString() ?? '',
      name: userData['fullName']?.toString() ?? userData['name']?.toString() ?? '',
      phone: userData['phone']?.toString() ?? '',
      role: userData['role']?.toString() ?? 'PATIENT',
    );

    return AuthResult(
      user: user,
      accessToken: accessToken,
    );
  }

  /// Resend OTP
  Future<void> resendOtp(String sessionId) async {
    await api.resendOtp(sessionId);
  }

  @override
  Future<AuthResult> login(
    String countryCode,
    String phone,
    String password, {
    String? otp,
  }) async {
    // This method is kept for backward compatibility
    // New implementation should use loginWithPassword and verifyLoginOtp
    throw UnimplementedError('Use loginWithPassword and verifyLoginOtp instead');
  }

  @override
  Future<int> register({
    required String fullName,
    required String countryCode,
    required String phone,
    required String password,
    required String role,
    String? email,
  }) async {
    // This method is kept for backward compatibility
    // New implementation should use registerWithPassword and verifyRegisterOtp
    throw UnimplementedError('Use registerWithPassword and verifyRegisterOtp instead');
  }

  @override
  Future<void> forgotPassword(String countryCode, String phone) async {
    await api.forgotPassword(countryCode, phone);
  }

  @override
  Future<String> verifyOtp(String countryCode, String phone, String otp) async {
    final result = await api.verifyOtp(countryCode, phone, otp);
    final token = result['resetToken'] as String? ?? result['token'] as String? ?? result['verificationToken'] as String? ?? '';
    if (token.isEmpty) {
      throw Exception('OTP verification failed: no token returned');
    }
    return token;
  }

  @override
  Future<void> resetPassword(String token, String password) async {
    await api.resetPassword(token, password);
  }
}

/// Result when login requires OTP
class LoginOtpRequiredResult {
  final String sessionId;
  final String phone;
  final String countryCode;

  LoginOtpRequiredResult({
    required this.sessionId,
    required this.phone,
    required this.countryCode,
  });
}

/// Result when registration requires OTP
class RegisterOtpRequiredResult {
  final String countryCode;
  final String phone;
  final String? registrationId;

  RegisterOtpRequiredResult({
    required this.countryCode,
    required this.phone,
    this.registrationId,
  });
}

