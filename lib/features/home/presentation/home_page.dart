import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:nuveta_patient_app/core/mock/mock_data.dart';
import 'package:nuveta_patient_app/core/theme/app_theme.dart';
import 'package:nuveta_patient_app/features/appointments/presentation/pages/appointments_page.dart';
import 'package:nuveta_patient_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:nuveta_patient_app/features/doctors/models/doctor_model.dart';
import 'package:nuveta_patient_app/features/doctors/presentation/providers/doctors_provider.dart';
import 'package:nuveta_patient_app/features/home/presentation/home_widgets.dart';
import 'package:nuveta_patient_app/features/home/presentation/widgets/action_card.dart';
import 'package:nuveta_patient_app/features/prescriptions/data/models/prescription_model.dart';
import 'package:nuveta_patient_app/features/prescriptions/presentation/pages/prescription_detail_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.asData?.value;
    final userName = user?.name ?? 'Patient';

    final visitRecords = MockDataGenerator.generateAppointments();
    final completedVisitRecords = visitRecords
        .where((record) => (record['status'] as String?)?.toLowerCase() == 'completed')
        .toList();
    final prescriptions = MockDataGenerator.generatePrescriptions()
        .map((item) => PrescriptionModel.fromJson(item))
        .toList();
    final patientRecords = completedVisitRecords
        .asMap()
        .entries
        .map((entry) {
      final index = entry.key;
      final record = entry.value;
      return {
        'type': record['type'] as String,
        'label': record['type'] == 'telehealth'
            ? 'Telehealth Visit'
            : record['type'] == 'home_visit'
                ? 'Home Visit'
                : 'Clinic Visit',
        'doctorName': record['doctorName'] as String,
        'dateTime': record['dateTime'] as DateTime,
        'note': record['notes'] as String,
        'location': record['location'] as String,
        'prescription': prescriptions[index % prescriptions.length] as PrescriptionModel,
      };
    }).toList();

    // Minimal home screen: only patient visit records, compact and scrollable
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        title: const Text('Nuveta'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Good afternoon, $userName',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 6),
            Text(
              'Here is your visit history and booking options.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.mutedColor),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ActionTile(
                    icon: Icons.calendar_month,
                    label: 'Book visit',
                    description: 'Schedule a new appointment',
                    onTap: () => context.push('/appointments'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ActionTile(
                    icon: Icons.home_outlined,
                    label: 'Home visit',
                    description: 'Request doctor at home',
                    onTap: () => context.push('/appointments'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ActionTile(
                    icon: Icons.video_camera_front,
                    label: 'Telehealth',
                    description: 'Request a doctor immediately',
                    onTap: () => _requestImmediateTelehealth(context, ref),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              'Visit History',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            ListView.separated(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: patientRecords.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, idx) {
                final record = patientRecords[idx];

                final prescription = record['prescription'] as PrescriptionModel;

                return CompactRecordTile(
                  label: record['label'] as String,
                  doctorName: record['doctorName'] as String,
                  dateTime: record['dateTime'] as DateTime,
                  visitType: record['type'] as String,
                  note: record['note'] as String,
                  location: record['location'] as String,
                  prescription: prescription,
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

Future<void> _requestImmediateTelehealth(BuildContext context, WidgetRef ref) async {
  final selectedDoctor = await _pickDoctor(context);
  if (selectedDoctor == null) return;

  final shouldSend = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Send Telehealth Request'),
        content: Text(
          'Send a request to ${selectedDoctor.name} (${selectedDoctor.specialization}). The doctor will review it and update you once they accept or reject.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Send Request'),
          ),
        ],
      );
    },
  );

  if (shouldSend != true) return;

  final appointment = {
    'id': 'telehealth-request-${DateTime.now().millisecondsSinceEpoch}',
    'doctorId': selectedDoctor.id,
    'doctorName': selectedDoctor.name,
    'specialty': selectedDoctor.specialization,
    'dateTime': DateTime.now().add(const Duration(minutes: 2)),
    'status': 'pending',
    'type': 'telehealth',
    'notes': 'Immediate telehealth request sent to ${selectedDoctor.name}.',
    'location': 'Virtual consultation',
  };

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Telehealth request sent to the doctor. Waiting for approval.'),
      duration: Duration(seconds: 3),
    ),
  );

  await Future.delayed(const Duration(milliseconds: 500));

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => AppointmentsPage(initialAppointment: appointment),
    ),
  );
}

Future<DoctorModel?> _pickDoctor(BuildContext context) async {
  return showDialog<DoctorModel>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Select Doctor'),
        content: SizedBox(
          width: double.maxFinite,
          height: 320,
          child: Consumer(
            builder: (context, ref, _) {
              final doctorsAsync = ref.watch(doctorsProvider);
              return doctorsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Text('Unable to load doctors: $error'),
                ),
                data: (doctors) {
                  if (doctors.isEmpty) {
                    return const Center(child: Text('No doctors available'));
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: doctors.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final doctor = doctors[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
                        leading: CircleAvatar(
                          radius: 22,
                          child: Text(
                            doctor.name.split(' ').map((part) => part.isNotEmpty ? part[0] : '').take(2).join(),
                          ),
                        ),
                        title: Text(doctor.name),
                        subtitle: Text('${doctor.specialization} · ${doctor.experience} yrs'),
                        trailing: Icon(
                          Icons.circle,
                          size: 12,
                          color: doctor.online ? Colors.green : Colors.grey,
                        ),
                        onTap: () => Navigator.of(context).pop(doctor),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      );
    },
  );
}

class RecordChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const RecordChip({required this.label, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const ActionTile({required this.icon, required this.label, required this.description, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
            ),
            const SizedBox(height: 16),
            Text(label, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }
}

class CompactRecordTile extends StatelessWidget {
  final String label;
  final String doctorName;
  final DateTime dateTime;
  final String visitType;
  final String note;
  final PrescriptionModel prescription;
  final String location;

  const CompactRecordTile({
    required this.label,
    required this.doctorName,
    required this.dateTime,
    required this.visitType,
    required this.note,
    required this.location,
    required this.prescription,
    super.key,
  });

  IconData _visitIcon(String type) {
    switch (type) {
      case 'telehealth':
        return Icons.video_camera_front;
      case 'home_visit':
        return Icons.home;
      default:
        return Icons.local_hospital;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = '${dateTime.day}/${dateTime.month}/${dateTime.year}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(_visitIcon(visitType), color: Theme.of(context).colorScheme.primary, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctorName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[700])),
                  ],
                ),
              ),
              Text(dateStr, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 14),
          Text(note, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 14),
          Row(
            children: [
              RecordChip(label: location, icon: Icons.location_on),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  visitType == 'telehealth' ? 'Telehealth' : visitType == 'home_visit' ? 'Home Visit' : 'Clinic',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PrescriptionDetailPage(prescription: prescription)),
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('View Prescription'),
          ),
        ],
      ),
    );
  }
}

