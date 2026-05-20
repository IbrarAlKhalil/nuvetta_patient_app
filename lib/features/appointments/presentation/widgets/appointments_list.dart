import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nuveta_patient_app/features/appointments/presentation/pages/telehealth_session_page.dart';

class AppointmentsList extends StatelessWidget {
  final List<Map<String, dynamic>> appointments;
  final bool isPrevious;
  final void Function(Map<String, dynamic> appointment)? onBookAgain;

  const AppointmentsList({
    required this.appointments,
    required this.isPrevious,
    this.onBookAgain,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return const Center(child: Text('No appointments yet'));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final apt = appointments[index];
        final status = (apt['status'] as String?)?.toLowerCase() ?? 'scheduled';
        final dateTime = apt['dateTime'] as DateTime;
        final dateLabel = DateFormat('dd MMM yyyy').format(dateTime);
        final timeLabel = DateFormat('hh:mm a').format(dateTime);

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(apt['doctorName'], style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(apt['specialty'], style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),
                Text('$dateLabel • $timeLabel', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                const SizedBox(height: 10),
                Text('Status: ${status == 'pending' ? 'Pending approval' : status == 'rejected' ? 'Rejected' : status == 'completed' ? 'Completed' : 'Confirmed'}'),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: _buildAction(context, apt, status),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAction(BuildContext context, Map<String, dynamic> apt, String status) {
    if (!isPrevious && status == 'pending') {
      return ElevatedButton(onPressed: null, child: const Text('Waiting for doctor approval'));
    }

    if (!isPrevious && status == 'rejected') {
      return ElevatedButton(onPressed: null, child: const Text('Request rejected'));
    }

    final isTelehealth = apt['type'] == 'telehealth';
    final label = isPrevious ? 'Book Again' : isTelehealth ? 'Join Video Visit' : 'View Appointment';

    return ElevatedButton(
      onPressed: () {
        if (isPrevious) {
          onBookAgain?.call(apt);
          return;
        }

        if (isTelehealth) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => TelehealthSessionPage(appointment: apt)));
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Appointment confirmed.')));
      },
      child: Text(label),
    );
  }
}
