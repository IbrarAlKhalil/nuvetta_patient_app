import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nuveta_patient_app/core/mock/mock_data.dart';

import '../widgets/appointments_list.dart';
import '../widgets/book_appointment_sheet.dart';

class AppointmentsPage extends ConsumerStatefulWidget {
  final Map<String, dynamic>? initialAppointment;

  const AppointmentsPage({super.key, this.initialAppointment});

  @override
  ConsumerState<AppointmentsPage> createState() =>
      _AppointmentsPageState();
}

class _AppointmentsPageState
    extends ConsumerState<AppointmentsPage>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  List<Map<String, dynamic>> _appointments = [];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    _appointments = MockDataGenerator.generateAppointments();
    if (widget.initialAppointment != null) {
      _appointments.insert(0, widget.initialAppointment!);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addAppointment(Map<String, dynamic> appointment) {
    setState(() {
      _appointments.insert(0, appointment);
    });
  }

  @override
  Widget build(BuildContext context) {

    final appointments = _appointments;

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
          AppointmentsList(
            appointments: upcoming,
            isPrevious: false,
            onBookAgain: _addAppointment,
          ),
          AppointmentsList(
            appointments: previous,
            isPrevious: true,
            onBookAgain: _addAppointment,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => BookAppointmentSheet(
              onBooked: _addAppointment,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

