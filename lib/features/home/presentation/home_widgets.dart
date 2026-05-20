import 'package:flutter/material.dart';
import 'package:nuveta_patient_app/features/prescriptions/data/models/prescription_model.dart';
import 'package:nuveta_patient_app/features/prescriptions/presentation/pages/prescription_detail_page.dart';

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
