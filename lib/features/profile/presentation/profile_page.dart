import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nuveta_patient_app/core/mock/mock_data.dart';
import 'package:nuveta_patient_app/features/profile/widgets/profile_header.dart';
import 'package:nuveta_patient_app/features/profile/widgets/profile_section.dart';
import 'package:nuveta_patient_app/features/profile/widgets/info_tile.dart';
import 'package:nuveta_patient_app/features/profile/widgets/metric_card.dart';
import 'package:nuveta_patient_app/features/profile/widgets/alert_box.dart';

import '../../../features/auth/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (user) {
          if (user == null) {
            return const Center(child: Text("Not logged in"));
          }

          final data = MockDataGenerator.generatePatientInfo();
          final dob = data['dateOfBirth'] as DateTime;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                /// HEADER
                ProfileHeader(data: data),

                const SizedBox(height: 16),

                /// PERSONAL
                ProfileSection(
                  title: "Personal Information",
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        InfoTile(icon: Icons.cake, label: "DOB", value: DateFormat('dd MMM yyyy').format(dob)),
                        InfoTile(icon: Icons.person, label: "Gender", value: data['gender']),
                        InfoTile(icon: Icons.bloodtype, label: "Blood", value: data['bloodType']),
                        InfoTile(icon: Icons.phone, label: "Phone", value: data['phone']),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// HEALTH
                ProfileSection(
                  title: "Health Overview",
                  children: [
                    Row(
                      children: [
                        MetricCard(title: "Height", value: "${data['height']} cm"),
                        const SizedBox(width: 10),
                        MetricCard(title: "Weight", value: "${data['weight']} kg"),
                        const SizedBox(width: 10),
                        MetricCard(
                          title: "BMI",
                          value: ((data['weight'] /
                                  ((data['height'] / 100) *
                                      (data['height'] / 100))))
                              .toStringAsFixed(1),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// ALERTS
                if ((data['allergies'] as List).isNotEmpty)
                  ProfileSection(
                    title: "Medical Alerts",
                    children: [
                      AlertBox(
                        title: "Allergies",
                        items: List<String>.from(data['allergies']),
                        color: Colors.red,
                        icon: Icons.warning,
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                /// LOGOUT
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.all(14),
                    ),
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                      context.go('/login');
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}