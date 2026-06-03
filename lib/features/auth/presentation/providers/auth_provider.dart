import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_api.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../profile/presentation/providers/profile_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(AuthApi());
});

final authProvider = AsyncNotifierProvider<AuthNotifier, UserEntity?>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<UserEntity?> {
  // For password reset flow
  String? resetToken;
  String? pendingCountryCode;
  String? pendingPhone;

  // For login OTP flow
  String? loginSessionId;
  String? loginCountryCode;
  String? loginPhone;

  // For registration OTP flow
  String? registrationId;
  String? registrationCountryCode;
  String? registrationPhone;
  String? registrationFullName;
  String? registrationEmail;

  @override
  Future<UserEntity?> build() async {
    final accessToken = await TokenStorage.getAccessToken();
    if (accessToken == null) return null;

    try {
      final profile = await ref.read(profileRepositoryProvider).getProfile();
      return UserModel(
        id: profile.id,
        email: profile.email,
        name: profile.fullName,
        phone: '${profile.countryCode}${profile.phone}',
        role: 'PATIENT',
      );
    } catch (_) {
      return null;
    }
  }

  /// ==================== LOGIN FLOW ====================

  /// Step 1: Login with phone and password
  /// This initiates the OTP flow
  Future<bool> loginWithPassword(
    String countryCode,
    String phone,
    String password,
  ) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider) as AuthRepositoryImpl;
      final result = await repository.loginWithPassword(countryCode, phone, password);

      if (result.accessToken != null) {
        await TokenStorage.saveAccessToken(result.accessToken!);
        var user = result.user;
        if (user == null) {
          final profile = await ref.read(profileRepositoryProvider).getProfile();
          user = UserModel(
            id: profile.id,
            email: profile.email,
            name: profile.fullName,
            phone: '${profile.countryCode}${profile.phone}',
            role: 'PATIENT',
          );
        }
        state = AsyncData(user);
        return false;
      }

      final otpResult = result.otpResult!;
      loginSessionId = otpResult.sessionId;
      loginCountryCode = otpResult.countryCode;
      loginPhone = otpResult.phone;

      state = const AsyncData(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  /// Step 2: Verify OTP for login
  Future<void> verifyLoginOtp(String otp) async {
    if (loginCountryCode == null || loginPhone == null) {
      throw Exception('No login session found. Please login first.');
    }

    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider) as AuthRepositoryImpl;
      final result = await repository.verifyLoginOtp(
        loginCountryCode!,
        loginPhone!,
        otp,
      );

      // Save token and user
      await TokenStorage.saveAccessToken(result.accessToken);

      var user = result.user;
      if (user == null) {
        final profile = await ref.read(profileRepositoryProvider).getProfile();
        user = UserModel(
          id: profile.id,
          email: profile.email,
          name: profile.fullName,
          phone: '${profile.countryCode}${profile.phone}',
          role: 'PATIENT',
        );
      }

      // Clear login session
      loginSessionId = null;
      loginCountryCode = null;
      loginPhone = null;

      state = AsyncData(user);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  /// Resend OTP for login
  Future<void> resendLoginOtp() async {
    if (loginSessionId == null) {
      throw Exception('No login session found');
    }

    try {
      final repository = ref.read(authRepositoryProvider) as AuthRepositoryImpl;
      await repository.resendOtp(loginSessionId!);
    } catch (error) {
      rethrow;
    }
  }

  /// ==================== REGISTRATION FLOW ====================

  /// Step 1: Register with user details
  /// This initiates the OTP flow or direct registration flow
  Future<RegisterWithPasswordResult> registerWithPassword({
    required String fullName,
    required String countryCode,
    required String phone,
    required String password,
    required String email,
  }) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider) as AuthRepositoryImpl;
      final result = await repository.registerWithPassword(
        fullName: fullName,
        countryCode: countryCode,
        phone: phone,
        password: password,
        role: 'PATIENT',
        email: email.isEmpty ? null : email,
      );

      if (result.accessToken != null) {
        await TokenStorage.saveAccessToken(result.accessToken!);
        var user = result.user;
        if (user == null) {
          final profile = await ref.read(profileRepositoryProvider).getProfile();
          user = UserModel(
            id: profile.id,
            email: profile.email,
            name: profile.fullName,
            phone: '${profile.countryCode}${profile.phone}',
            role: 'PATIENT',
          );
        }
        state = AsyncData(user);
        return result;
      }

      if (result.requiresOtp) {
        registrationId = result.otpResult?.registrationId;
        registrationCountryCode = result.otpResult?.countryCode;
        registrationPhone = result.otpResult?.phone;
        registrationFullName = fullName;
        registrationEmail = email;
        state = const AsyncData(null);
        return result;
      }

      state = const AsyncData(null);
      return result;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  /// Step 2: Verify OTP for registration
  Future<void> verifyRegisterOtp(String otp) async {
    if (registrationCountryCode == null || registrationPhone == null) {
      throw Exception('No registration session found. Please register first.');
    }

    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider) as AuthRepositoryImpl;
      final result = await repository.verifyRegisterOtp(
        registrationCountryCode!,
        registrationPhone!,
        otp,
      );

      // Save token and user
      await TokenStorage.saveAccessToken(result.accessToken);

      var user = result.user;
      if (user == null) {
        final profile = await ref.read(profileRepositoryProvider).getProfile();
        user = UserModel(
          id: profile.id,
          email: profile.email,
          name: profile.fullName,
          phone: '${profile.countryCode}${profile.phone}',
          role: 'PATIENT',
        );
      }

      // Clear registration session
      registrationId = null;
      registrationCountryCode = null;
      registrationPhone = null;
      registrationFullName = null;
      registrationEmail = null;

      state = AsyncData(user);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  /// Resend OTP for registration
  Future<void> resendRegisterOtp() async {
    if (registrationId == null) {
      throw Exception('No registration session found');
    }

    try {
      final repository = ref.read(authRepositoryProvider) as AuthRepositoryImpl;
      await repository.resendOtp(registrationId!);
    } catch (error) {
      rethrow;
    }
  }

  /// ==================== PASSWORD RESET FLOW ====================

  Future<void> forgotPassword(String countryCode, String phone) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);

    try {
      pendingCountryCode = countryCode;
      pendingPhone = phone;
      await repository.forgotPassword(countryCode, phone);
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> verifyOtp(String otp) async {
    if (pendingCountryCode == null || pendingPhone == null) {
      throw Exception('No phone number found for OTP verification');
    }

    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);

    try {
      resetToken = await repository.verifyOtp(
        pendingCountryCode!,
        pendingPhone!,
        otp,
      );
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  Future<void> resetPassword(String token, String password) async {
    state = const AsyncLoading();
    final repository = ref.read(authRepositoryProvider);

    try {
      await repository.resetPassword(token, password);
      resetToken = null;
      pendingCountryCode = null;
      pendingPhone = null;
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  /// ==================== LOGOUT ====================

  /// Logout and clear stored token
  Future<void> logout() async {
    await TokenStorage.clear();
    // Clear all session data
    loginSessionId = null;
    loginCountryCode = null;
    loginPhone = null;
    registrationId = null;
    registrationCountryCode = null;
    registrationPhone = null;
    registrationFullName = null;
    registrationEmail = null;
    resetToken = null;
    pendingCountryCode = null;
    pendingPhone = null;
    state = const AsyncData(null);
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await TokenStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}

