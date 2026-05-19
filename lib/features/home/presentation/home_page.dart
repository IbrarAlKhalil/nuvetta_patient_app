import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:nuveta_patient_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:nuveta_patient_app/features/home/presentation/widgets/action_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.asData?.value;
    final userName = user?.name ?? 'Patient';
    final patientId = user?.id ?? 'N/A';
    final patientEmail = user?.email ?? 'patient@example.com';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Nuveta'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => context.push('/appointments'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $userName',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Your patient record, station status, medication and prescription summary are all here.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Patient Record',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 14),
                    Text('Patient ID', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Text(patientId, style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 12),
                    Text('Email', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Text(patientEmail, style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _RecordChip(label: 'Allergies: None', icon: Icons.health_and_safety),
                        _RecordChip(label: 'Blood Type: O+', icon: Icons.bloodtype),
                        _RecordChip(label: 'Condition: Hypertension', icon: Icons.monitor_heart),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Attending Station', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 12),
                          Text('Telehealth', style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 8),
                          Text('Dr. Sarah Owens', style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 8),
                          Text('Station 4 • Online', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Medication', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 12),
                          Text('Metformin 500mg', style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 6),
                          Text('Once daily • Morning', style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 12),
                          Text('Atorvastatin 20mg', style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 6),
                          Text('Once daily • Night', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Prescriptions', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    const _PrescriptionTile(
                      title: 'Blood pressure support',
                      subtitle: 'Refill due in 5 days',
                    ),
                    const SizedBox(height: 10),
                    const _PrescriptionTile(
                      title: 'Vitamin D supplement',
                      subtitle: '2 refills remaining',
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => context.push('/profile'),
                        child: const Text('View full prescriptions'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.4,
              children: [
                ActionCard(
                  icon: Icons.calendar_month,
                  title: 'Book Appointment',
                  onTap: () => context.push('/appointments'),
                ),
                ActionCard(
                  icon: Icons.video_camera_front,
                  title: 'Join Telehealth',
                  onTap: () => context.push('/appointments'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _RecordChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _PrescriptionTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _PrescriptionTile({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary),
        ],
      ),
    );
  }
}

