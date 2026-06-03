import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:nuveta_patient_app/features/home/presentation/home_page.dart';
import 'package:nuveta_patient_app/features/profile/presentation/profile_page.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/totp_verify_page.dart';
import '../../features/auth/presentation/pages/verify_otp_page.dart';
import '../../features/appointments/presentation/pages/appointments_page.dart';
import '../../features/prescriptions/presentation/pages/prescriptions_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../shared/layouts/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefresh(ref),

    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final user = authState.asData?.value;

      final isLoggedIn = user != null;
      final location = state.matchedLocation;

      final isSplash = location == '/';
      final isLogin = location == '/login';
      final isRegister = location == '/register';
      final isForgot = location == '/forgot-password';
      final isReset = location == '/reset-password';
      final isVerifyOtp = location == '/verify-otp';
      final isAuthPage = isLogin || isRegister || isForgot || isReset || isVerifyOtp;

      if (isSplash) return null;
      if (!isLoggedIn && !isAuthPage) return '/login';
      if (isLoggedIn && isAuthPage) return '/home';
      return null;
    },

    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) => const VerifyOtpPage(),
      ),
      GoRoute(
        path: '/totp-verify',
        builder: (context, state) => const TotpVerifyPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/appointments',
            builder: (context, state) => const AppointmentsPage(),
          ),
          GoRoute(
            path: '/prescriptions',
            builder: (context, state) => const PrescriptionsPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
});

class GoRouterRefresh extends ChangeNotifier {
  GoRouterRefresh(Ref ref) {
    ref.listen(authProvider, (_, __) {
      notifyListeners();
    });
  }
}
