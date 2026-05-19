import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/medical_history_provider.dart';

class MedicalHistoryPage extends ConsumerWidget {
  const MedicalHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicalHistoryAsync = ref.watch(medicalHistoryProvider);
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical History'),
        elevation: 0,
      ),
      body: medicalHistoryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err'),
        ),
        data: (medicalHistory) {
          if (medicalHistory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medical_information, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No medical history',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(isMobile ? 12 : 24),
            itemCount: medicalHistory.length,
            itemBuilder: (context, index) {
              final history = medicalHistory[index];
              final isOngoing = history.status == 'ongoing';

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              history.condition,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isOngoing ? Colors.orange[100] : Colors.green[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              isOngoing ? 'Ongoing' : 'Resolved',
                              style: TextStyle(
                                color: isOngoing ? Colors.orange[900] : Colors.green[900],
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        label: 'Started:',
                        value: '${history.startDate.day}/${history.startDate.month}/${history.startDate.year}',
                      ),
                      if (history.endDate != null)
                        _InfoRow(
                          label: 'Ended:',
                          value: '${history.endDate!.day}/${history.endDate!.month}/${history.endDate!.year}',
                        ),
                      const SizedBox(height: 8),
                      _InfoRow(
                        label: 'Treatment:',
                        value: history.treatment,
                      ),
                      const SizedBox(height: 8),
                      _InfoRow(
                        label: 'Notes:',
                        value: history.notes,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
