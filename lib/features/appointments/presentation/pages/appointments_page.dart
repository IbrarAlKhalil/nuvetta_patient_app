import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:nuveta_patient_app/core/mock/mock_data.dart';

import '../widgets/book_appointment_sheet.dart';

class AppointmentsPage extends ConsumerStatefulWidget {
  const AppointmentsPage({super.key});

  @override
  ConsumerState<AppointmentsPage> createState() =>
      _AppointmentsPageState();
}

class _AppointmentsPageState
    extends ConsumerState<AppointmentsPage>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final appointments =
    MockDataGenerator.generateAppointments();

    final now = DateTime.now();

    final upcoming = appointments
        .where(
          (a) =>
      (a['dateTime'] as DateTime)
          .isAfter(now),
    )
        .toList();

    final previous = appointments
        .where(
          (a) =>
      (a['dateTime'] as DateTime)
          .isBefore(now),
    )
        .toList();

    return Scaffold(

      appBar: AppBar(
        title: const Text('Appointments'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Previous'),
          ],
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [

          _AppointmentsList(
            appointments: upcoming,
            isPrevious: false,
          ),

          _AppointmentsList(
            appointments: previous,
            isPrevious: true,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {

          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) =>
            const BookAppointmentSheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _AppointmentsList extends StatelessWidget {

  final List appointments;
  final bool isPrevious;

  const _AppointmentsList({
    required this.appointments,
    required this.isPrevious,
  });

  @override
  Widget build(BuildContext context) {

    if (appointments.isEmpty) {
      return const Center(
        child: Text('No appointments'),
      );
    }

    return ListView.builder(

      padding: const EdgeInsets.all(16),

      itemCount: appointments.length,

      itemBuilder: (context, index) {

        final apt = appointments[index];

        final dateTime =
        apt['dateTime'] as DateTime;

        return Card(

          margin:
          const EdgeInsets.only(bottom: 16),

          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  apt['doctorName'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(apt['specialty']),

                const SizedBox(height: 12),

                Row(
                  children: [

                    const Icon(Icons.calendar_today),

                    const SizedBox(width: 8),

                    Text(
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(dateTime),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [

                    const Icon(Icons.access_time),

                    const SizedBox(width: 8),

                    Text(
                      DateFormat(
                        'hh:mm a',
                      ).format(dateTime),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [

                    const Icon(Icons.location_on),

                    const SizedBox(width: 8),

                    Expanded(
                      child:
                      Text(apt['location']),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      isPrevious
                          ? 'Book Again'
                          : 'View Details',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}