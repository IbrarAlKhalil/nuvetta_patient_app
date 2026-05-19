import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nuveta_patient_app/features/doctors/models/doctor_model.dart';
import 'package:nuveta_patient_app/features/doctors/presentation/doctors_page.dart';
import 'package:nuveta_patient_app/features/lab_tests/presentation/pages/lab_booking_page.dart';
import 'package:nuveta_patient_app/features/lab_tests/presentation/pages/lab_test_detail_page.dart';
import 'package:nuveta_patient_app/features/pharmacy/presentation/pages/pharamacy_page.dart';
import 'package:nuveta_patient_app/features/profile/presentation/profile_page.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/doctors/presentation/pages/doctor_details_page.dart';
import '../../features/appointments/presentation/pages/appointments_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/medical_history/presentation/pages/medical_history_page.dart';
import '../../features/prescriptions/presentation/pages/prescriptions_page.dart';
import '../../features/lab_tests/presentation/pages/lab_tests_page.dart';
import '../../features/messages/presentation/pages/messages_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
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
      final isAuthPage = isLogin || isRegister;

      // always allow splash
      if (isSplash) return null;

      // not logged in → only login/register allowed
      if (!isLoggedIn && !isAuthPage) {
        return '/login';
      }

      // logged in → block auth pages
      if (isLoggedIn && isAuthPage) {
        return '/home';
      }

      return null;
    },

    routes: [

      // ================= SPLASH =================
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),

      // ================= AUTH =================
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),

      // ================= MAIN =================
      GoRoute(
        path: '/home',
        builder: (context, state) => const AppShell(),
      ),

      // ================= FEATURES =================
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchPage(),
      ),

      GoRoute(
        path: '/appointments',
        builder: (context, state) => const AppointmentsPage(),
      ),

      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsPage(),
      ),

      GoRoute(
        path: '/medical-history',
        builder: (context, state) => const MedicalHistoryPage(),
      ),

      GoRoute(
        path: '/prescriptions',
        builder: (context, state) => const PrescriptionsPage(),
      ),

      GoRoute(
        path: '/lab-tests',
        builder: (context, state) => const LabTestsPage(),
      ),

      GoRoute(
        path: '/messages',
        builder: (context, state) => const MessagesPage(),
      ),

      GoRoute(
        path: '/doctors',
        builder: (context, state) => const DoctorsPage(),
      ),

      GoRoute(
        path: '/lab-test-detail',
        builder: (context, state) {
          final test = state.extra as dynamic;
          return LabTestDetailPage(test: test);
        },
      ),

      // ================= DOCTOR DETAILS =================
      GoRoute(
        path: '/doctor-details',
        builder: (context, state) {
          final doctor = state.extra as DoctorModel;
          return DoctorDetailsPage(doctor: doctor);
        },
      ),
      GoRoute(
        path: '/lab-booking',
        builder: (context, state) {
          return LabBookingPage();
        },
      ),
      GoRoute(
        path: '/profile', 
        builder: (context, state) => const ProfilePage()),

      GoRoute(
        path: '/pharacy',
        builder: (context, state) => PharmacyPage(),
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