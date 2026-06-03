import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/prescription_model.dart';
import 'package:nuveta_patient_app/core/utils/pdf_generator.dart';

class PrescriptionDetailPage extends ConsumerWidget {
  final PrescriptionModel prescription;

  const PrescriptionDetailPage({
    super.key,
    required this.prescription,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Clinic-style prescription card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Clinic header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nuveta Clinic', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('123 Health Ave • City, Country', style: Theme.of(context).textTheme.bodySmall),
                            Text('Tel: (555) 123-4567', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      // Rx symbol
                      Text('Rx', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),

                  const Divider(height: 20),

                  // Patient & prescription header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Patient:', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Patient Name', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Date:', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('${prescription.prescribedDate.day}/${prescription.prescribedDate.month}/${prescription.prescribedDate.year}', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Medication block (styled like a prescription)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(prescription.medicationName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('${prescription.dosage} — ${prescription.frequency}', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        if (prescription.instructions.isNotEmpty) ...[
                          Text('Instructions:', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(prescription.instructions, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Footer with doctor and signature
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Prescribed by', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                            Text(prescription.doctorName, style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(width: 140, height: 1, color: Colors.grey.shade400),
                          const SizedBox(height: 4),
                          Text('Signature', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text('Request Refill'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () async {
                          await exportPrescriptionPdf(context, prescription);
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text('Download'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

